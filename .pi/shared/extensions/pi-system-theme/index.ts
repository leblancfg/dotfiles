import { execFile } from "node:child_process";
import { mkdir, readFile, rm, writeFile } from "node:fs/promises";
import os from "node:os";
import path from "node:path";
import { promisify } from "node:util";
import type { ExtensionAPI, ExtensionCommandContext, ExtensionContext } from "@mariozechner/pi-coding-agent";

const execFileAsync = promisify(execFile);

type Config = {
    darkTheme: string;
    lightTheme: string;
    pollMs: number;
};

type Appearance = "dark" | "light";

const DEFAULT_CONFIG: Config = {
    darkTheme: "dark",
    lightTheme: "light",
    pollMs: 2000,
};

const GLOBAL_CONFIG_PATH = path.join(os.homedir(), ".pi", "agent", "system-theme.json");
const DETECTION_TIMEOUT_MS = 1200;
const MIN_POLL_MS = 500;

function isObject(value: unknown): value is Record<string, unknown> {
    return typeof value === "object" && value !== null && !Array.isArray(value);
}

function toThemeName(value: unknown, fallback: string): string {
    if (typeof value !== "string") {
        return fallback;
    }

    const trimmed = value.trim();
    return trimmed.length > 0 ? trimmed : fallback;
}

function toPollMs(value: unknown, fallback: number): number {
    if (typeof value !== "number" || !Number.isFinite(value)) {
        return fallback;
    }

    return Math.max(MIN_POLL_MS, Math.round(value));
}

function getOverrides(config: Config): Partial<Config> {
    const overrides: Partial<Config> = {};

    if (config.darkTheme !== DEFAULT_CONFIG.darkTheme) {
        overrides.darkTheme = config.darkTheme;
    }

    if (config.lightTheme !== DEFAULT_CONFIG.lightTheme) {
        overrides.lightTheme = config.lightTheme;
    }

    if (config.pollMs !== DEFAULT_CONFIG.pollMs) {
        overrides.pollMs = config.pollMs;
    }

    return overrides;
}

async function loadConfig(): Promise<Config> {
    const config = { ...DEFAULT_CONFIG };

    try {
        const rawContent = await readFile(GLOBAL_CONFIG_PATH, "utf8");
        const parsed = JSON.parse(rawContent) as unknown;

        if (!isObject(parsed)) {
            console.warn(`[pi-system-theme] Ignoring ${GLOBAL_CONFIG_PATH}: expected JSON object.`);
            return config;
        }

        config.darkTheme = toThemeName(parsed.darkTheme, config.darkTheme);
        config.lightTheme = toThemeName(parsed.lightTheme, config.lightTheme);
        config.pollMs = toPollMs(parsed.pollMs, config.pollMs);

        return config;
    } catch (error) {
        if ((error as { code?: string })?.code === "ENOENT") {
            return config;
        }

        const message = error instanceof Error ? error.message : String(error);
        console.warn(`[pi-system-theme] Failed to read ${GLOBAL_CONFIG_PATH}: ${message}`);
        return config;
    }
}

async function saveConfig(config: Config): Promise<{ wroteFile: boolean; overrideCount: number }> {
    const overrides = getOverrides(config);
    const overrideCount = Object.keys(overrides).length;

    if (overrideCount === 0) {
        await rm(GLOBAL_CONFIG_PATH, { force: true });
        return {
            wroteFile: false,
            overrideCount,
        };
    }

    await mkdir(path.dirname(GLOBAL_CONFIG_PATH), { recursive: true });
    await writeFile(GLOBAL_CONFIG_PATH, `${JSON.stringify(overrides, null, 4)}\n`, "utf8");

    return {
        wroteFile: true,
        overrideCount,
    };
}

function extractStderr(error: unknown): string {
    if (!error || typeof error !== "object") {
        return "";
    }

    const stderr = (error as { stderr?: unknown }).stderr;
    return typeof stderr === "string" ? stderr : "";
}

function normalizeSettingValue(value: string): string {
    const trimmed = value.trim().toLowerCase();

    if ((trimmed.startsWith("'") && trimmed.endsWith("'")) || (trimmed.startsWith('"') && trimmed.endsWith('"'))) {
        return trimmed.slice(1, -1);
    }

    return trimmed;
}

function isSupportedPlatform(): boolean {
    return process.platform === "darwin" || process.platform === "linux" || process.platform === "win32";
}

function parseMacAppearance(value: string): Appearance | null {
    if (value === "dark") {
        return "dark";
    }

    if (value === "light") {
        return "light";
    }

    return null;
}

function parseGnomeColorScheme(value: string | null): Appearance | null {
    if (value === "prefer-dark") {
        return "dark";
    }

    if (value === "prefer-light") {
        return "light";
    }

    return null;
}

function parseGtkThemeAppearance(value: string | null): Appearance | null {
    if (!value) {
        return null;
    }

    if (value.includes("dark")) {
        return "dark";
    }

    if (value.includes("light")) {
        return "light";
    }

    return null;
}

function parseWindowsAppsUseLightThemeValue(registryOutput: string): Appearance | null {
    const match = registryOutput.match(/AppsUseLightTheme\s+REG_DWORD\s+(\S+)/i);
    if (!match) {
        return null;
    }

    const rawValue = match[1] ?? "";

    let parsedValue: number;
    if (rawValue.toLowerCase().startsWith("0x")) {
        parsedValue = Number.parseInt(rawValue.slice(2), 16);
    } else {
        parsedValue = Number.parseInt(rawValue, 10);
    }

    if (parsedValue === 0) {
        return "dark";
    }

    if (parsedValue === 1) {
        return "light";
    }

    return null;
}

async function readGnomeInterfaceSetting(key: string): Promise<string | null> {
    try {
        const { stdout } = await execFileAsync("gsettings", ["get", "org.gnome.desktop.interface", key], {
            timeout: DETECTION_TIMEOUT_MS,
            windowsHide: true,
        });

        return normalizeSettingValue(stdout);
    } catch {
        return null;
    }
}

async function detectMacAppearance(): Promise<Appearance | null> {
    try {
        const { stdout } = await execFileAsync("/usr/bin/defaults", ["read", "-g", "AppleInterfaceStyle"], {
            timeout: DETECTION_TIMEOUT_MS,
            windowsHide: true,
        });

        return parseMacAppearance(normalizeSettingValue(stdout));
    } catch (error) {
        const stderr = extractStderr(error).toLowerCase();
        if (stderr.includes("does not exist")) {
            return "light";
        }

        return null;
    }
}

async function detectLinuxAppearance(): Promise<Appearance | null> {
    const fromColorScheme = parseGnomeColorScheme(await readGnomeInterfaceSetting("color-scheme"));
    if (fromColorScheme) {
        return fromColorScheme;
    }

    return parseGtkThemeAppearance(await readGnomeInterfaceSetting("gtk-theme"));
}

async function detectWindowsAppearance(): Promise<Appearance | null> {
    try {
        const { stdout } = await execFileAsync(
            "reg",
            [
                "query",
                "HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize",
                "/v",
                "AppsUseLightTheme",
            ],
            {
                timeout: DETECTION_TIMEOUT_MS,
                windowsHide: true,
            },
        );

        return parseWindowsAppsUseLightThemeValue(stdout);
    } catch {
        return null;
    }
}

async function detectAppearance(): Promise<Appearance | null> {
    switch (process.platform) {
        case "darwin":
            return detectMacAppearance();
        case "linux":
            return detectLinuxAppearance();
        case "win32":
            return detectWindowsAppearance();
        default:
            return null;
    }
}

async function promptTheme(
    ctx: ExtensionCommandContext,
    label: string,
    currentValue: string,
): Promise<string | undefined> {
    const next = await ctx.ui.input(label, currentValue);
    if (next === undefined) {
        return undefined;
    }

    const trimmed = next.trim();
    return trimmed.length > 0 ? trimmed : currentValue;
}

async function promptPollMs(ctx: ExtensionCommandContext, currentValue: number): Promise<number | undefined> {
    while (true) {
        const next = await ctx.ui.input("Poll interval (ms)", String(currentValue));
        if (next === undefined) {
            return undefined;
        }

        const trimmed = next.trim();
        if (trimmed.length === 0) {
            return currentValue;
        }

        const parsed = Number.parseInt(trimmed, 10);
        if (Number.isFinite(parsed) && parsed >= MIN_POLL_MS) {
            return parsed;
        }

        ctx.ui.notify(`Enter a whole number >= ${MIN_POLL_MS}.`, "warning");
    }
}

function canManageThemes(ctx: ExtensionContext): boolean {
    if (!ctx.hasUI) {
        return false;
    }

    return ctx.ui.getAllThemes().length > 0;
}

function notifyInfoIfUI(ctx: ExtensionContext, message: string): void {
    if (!ctx.hasUI) {
        return;
    }

    ctx.ui.notify(message, "info");
}

function hasThemeOverrides(config: Config): boolean {
    return config.darkTheme !== DEFAULT_CONFIG.darkTheme || config.lightTheme !== DEFAULT_CONFIG.lightTheme;
}

function isDefaultThemeName(themeName: string | undefined): boolean {
    return themeName === DEFAULT_CONFIG.darkTheme || themeName === DEFAULT_CONFIG.lightTheme;
}

function shouldAutoSync(ctx: ExtensionContext, config: Config): boolean {
    if (!canManageThemes(ctx)) {
        return false;
    }

    if (hasThemeOverrides(config)) {
        return true;
    }

    return isDefaultThemeName(ctx.ui.theme.name);
}

export default function systemThemeExtension(pi: ExtensionAPI): void {
    let activeConfig: Config = { ...DEFAULT_CONFIG };
    let intervalId: ReturnType<typeof setInterval> | null = null;
    let syncInProgress = false;
    let lastSetThemeError: string | null = null;
    let didWarnDefaultThemeFallback = false;

    function maybeNotifyDefaultThemeFallback(ctx: ExtensionContext): void {
        if (didWarnDefaultThemeFallback || !canManageThemes(ctx) || hasThemeOverrides(activeConfig)) {
            return;
        }

        const currentTheme = ctx.ui.theme.name;
        if (isDefaultThemeName(currentTheme)) {
            return;
        }

        const displayTheme = currentTheme ?? "unknown";

        didWarnDefaultThemeFallback = true;
        ctx.ui.notify(
            `Current theme "${displayTheme}" is custom. Skipping default dark/light auto-sync. Configure /system-theme to enable syncing.`,
            "info",
        );
    }

    async function syncTheme(ctx: ExtensionContext): Promise<void> {
        if (!shouldAutoSync(ctx, activeConfig) || syncInProgress) {
            return;
        }

        syncInProgress = true;

        try {
            const appearance = await detectAppearance();
            if (!appearance) {
                return;
            }

            const targetTheme = appearance === "dark" ? activeConfig.darkTheme : activeConfig.lightTheme;
            if (ctx.ui.theme.name === targetTheme) {
                return;
            }

            const result = ctx.ui.setTheme(targetTheme);
            if (result.success) {
                lastSetThemeError = null;
                return;
            }

            const message = result.error ?? "unknown error";
            const errorKey = `${targetTheme}:${message}`;
            if (errorKey !== lastSetThemeError) {
                lastSetThemeError = errorKey;
                console.warn(`[pi-system-theme] Failed to set theme "${targetTheme}": ${message}`);
            }
        } finally {
            syncInProgress = false;
        }
    }

    function restartPolling(ctx: ExtensionContext): void {
        if (intervalId) {
            clearInterval(intervalId);
            intervalId = null;
        }

        if (!shouldAutoSync(ctx, activeConfig)) {
            return;
        }

        intervalId = setInterval(() => {
            void syncTheme(ctx);
        }, activeConfig.pollMs);
    }

    pi.registerCommand("system-theme", {
        description: "Configure pi-system-theme",
        handler: async (_args, ctx) => {
            if (!isSupportedPlatform()) {
                notifyInfoIfUI(ctx, "pi-system-theme currently supports macOS, Linux (GNOME gsettings), and Windows.");
                return;
            }

            if (!canManageThemes(ctx)) {
                notifyInfoIfUI(ctx, "pi-system-theme settings require interactive theme support.");
                return;
            }

            const draft: Config = { ...activeConfig };

            while (true) {
                const darkOption = `Dark theme: ${draft.darkTheme}`;
                const lightOption = `Light theme: ${draft.lightTheme}`;
                const pollOption = `Poll interval (ms): ${draft.pollMs}`;
                const saveOption = "Save and apply";
                const cancelOption = "Cancel";

                const choice = await ctx.ui.select("pi-system-theme", [
                    darkOption,
                    lightOption,
                    pollOption,
                    saveOption,
                    cancelOption,
                ]);

                if (choice === undefined || choice === cancelOption) {
                    return;
                }

                if (choice === darkOption) {
                    const next = await promptTheme(ctx, "Dark theme", draft.darkTheme);
                    if (next !== undefined) {
                        draft.darkTheme = next;
                    }
                    continue;
                }

                if (choice === lightOption) {
                    const next = await promptTheme(ctx, "Light theme", draft.lightTheme);
                    if (next !== undefined) {
                        draft.lightTheme = next;
                    }
                    continue;
                }

                if (choice === pollOption) {
                    const next = await promptPollMs(ctx, draft.pollMs);
                    if (next !== undefined) {
                        draft.pollMs = next;
                    }
                    continue;
                }

                if (choice === saveOption) {
                    activeConfig = draft;

                    try {
                        const result = await saveConfig(activeConfig);
                        if (result.wroteFile) {
                            ctx.ui.notify(
                                `Saved ${result.overrideCount} override(s) to ${GLOBAL_CONFIG_PATH}.`,
                                "info",
                            );
                        } else {
                            ctx.ui.notify("No overrides left. Using defaults.", "info");
                        }
                    } catch (error) {
                        const message = error instanceof Error ? error.message : String(error);
                        ctx.ui.notify(`Failed to save config: ${message}`, "error");
                        return;
                    }

                    await syncTheme(ctx);
                    restartPolling(ctx);
                    maybeNotifyDefaultThemeFallback(ctx);
                    return;
                }
            }
        },
    });

    pi.on("session_start", async (_event, ctx) => {
        if (!isSupportedPlatform()) {
            return;
        }

        activeConfig = await loadConfig();

        if (!shouldAutoSync(ctx, activeConfig)) {
            maybeNotifyDefaultThemeFallback(ctx);
            return;
        }

        await syncTheme(ctx);
        restartPolling(ctx);
    });

    pi.on("session_shutdown", () => {
        if (!intervalId) {
            return;
        }

        clearInterval(intervalId);
        intervalId = null;
    });
}
