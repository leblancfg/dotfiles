# /// script
# requires-python = ">=3.11"
# dependencies = ["clipboard", "pandas", "tabulate"]
# ///

import sys

import clipboard
import pandas as pd


def tsv_clipboard():
    try:
        df = pd.read_clipboard()
        text = df.to_markdown(index=False)
        clipboard.copy(text)
        return text
    except:  # noqa
        print('😞 No dice. Make sure your clipboard contains readable data.')
        sys.exit(1)


if __name__ == '__main__':
    text = tsv_clipboard()
    print('✨ Done! ✨\n\n---\n')
    print(text)
