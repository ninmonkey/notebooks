
## Coercible Compare


| Ex | Result |
| - | - |
| `Blank() = Blank()` | ✅ True |
| `Blank() = 0` | ✅ True |
| `Blank() = ""` | ✅ True |

## Exactly Equal


| Ex | Result |
| - | - |
| `Blank() == Blank()` | ✅ True |
| `Blank() == 0` | ⛔False |
| `Blank() == ""` | ⛔False |
