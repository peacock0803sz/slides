def without_typing(s):
    return "Hello, " + s


without_typing("PyCon US 2022")


without_typing(1)


def with_typing(s: str) -> str:
    return "Hello, " + s


with_typing("PyCon US 2022")
#


with_typing(1)
without_typing(1)
