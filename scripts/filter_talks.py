#!/usr/bin/env python3.11

import json
import re
import os
import sys

TIMESTAMP_PREFIX = re.compile(r"\d{4}-\d{2}-\d{2}_")


def normalize_title(s: str) -> str:
    """
    >>> normalize_title("talks/2024-01-01_the-talk-title/slides.md")
    'the-talk-title'
    >>> normalize_title("talks/2000-08-03_my_birthday/slides.md")
    'my_birthday'
    """
    return TIMESTAMP_PREFIX.sub("", s.split("/")[1])


def main():
    if os.environ.get("GITHUB_OUPTUT"):
        print("Output has been already set")
        sys.exit(1)

    input_: list[str] = json.load(sys.stdin)
    output = list({normalize_title(s) for s in input_})

    result = "result=" + json.dumps(output)
    print(result)


if __name__ == "__main__":
    main()
