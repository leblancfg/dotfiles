// Tags the tmux pane with the pi session file it runs, as the pane option
// @pi_session_file. scripts/tmux-pi-resurrect reads it on tmux-resurrect save
// and resumes the exact session after a tmux restart.
// @ts-nocheck

export default function (pi) {
	const pane = process.env.TMUX_PANE;
	if (!pane) return;

	const tag = (value?: string) => {
		const args = value
			? ["set-option", "-p", "-t", pane, "@pi_session_file", value]
			: ["set-option", "-p", "-u", "-t", pane, "@pi_session_file"];
		return pi.exec("tmux", args, { timeout: 2000 }).catch(() => {});
	};

	// session_start also fires on /new, /resume, and /fork, so the tag follows
	// the session the pane shows now.
	pi.on("session_start", async (_event, ctx) => {
		// Print, json, and rpc runs (subagents) share the pane with a parent.
		if (ctx.mode !== "tui") return;
		const file = ctx.sessionManager?.getSessionFile?.();
		if (file) await tag(file);
	});

	pi.on("session_shutdown", async (_event, ctx) => {
		if (ctx.mode !== "tui") return;
		await tag();
	});
}
