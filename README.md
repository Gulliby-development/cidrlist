<p align="center"><img src="docs/logo.svg" width="96" alt="" /></p>

# cidrlist

[![CI](https://github.com/Gulliby-development/cidrlist/actions/workflows/ci.yml/badge.svg)](https://github.com/Gulliby-development/cidrlist/actions/workflows/ci.yml) [![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

cidrlist is a small command-line tool written in Elixir that works on lists of IPv4 networks such as `10.0.0.0/8`, `192.168.1.0/24` or a single address like `203.0.113.7`. It reads a list from standard input, one network per line, and can validate it, sort it, merge it, count the addresses it covers, list the addresses nobody covers, name the networks that hold an address, or cut every network into smaller ones.

It is for people who maintain firewall rule sets, routing tables or allow lists, and who use it in a terminal, in a script or in CI. It needs no network and no clock, and it uses only the Elixir standard library.

## Usage

Build the escript and run it from the repository directory:

```text
mix escript.build
escript cidrlist COMMAND
```

Or run it without building:

```text
mix run -e 'Cidrlist.main(["COMMAND"])'
```

Synopsis, in this order:

```text
usage: cidrlist check
       cidrlist sort [--style STYLE]
       cidrlist merge [--style STYLE]
       cidrlist count [--mode MODE]
       cidrlist gaps --within NET [--style STYLE]
       cidrlist contains --ip IP
       cidrlist split --prefix N [--style STYLE]
```

- `check` validates the list.
- `sort` orders the networks.
- `merge` writes the fewest networks that cover the same addresses.
- `count` counts the covered addresses. `--mode` is `addresses` (the default) or `hosts`.
- `gaps` lists the addresses of `--within NET` that the list does not cover.
- `contains` names the networks that hold the address given by `--ip`.
- `split` cuts every network into networks of prefix length `--prefix` (0 to 32, no leading zero).

`--style` is one of `cidr` (the default), `range`, `mask` or `hex`. Every option takes the next word as its value; there is no `--option=value` form, and an option may be given only once.

Every command reads the list of networks from standard input. `help`, `-h` or `--help` as the first word prints the usage above and exits 0. `--version` prints `cidrlist 0.1.0` and exits 0. With no word, the usage goes to standard error and the exit status is 2.

## Networks

The input is cut into lines at each line feed. A final line without a line feed still counts, and one carriage return at the end of a line is dropped. A line that holds only spaces and tabs, or whose first word starts with `#`, is skipped. Every other line holds exactly one word, a network; spaces and tabs at the ends of a line are ignored. The list may have at most 40 lines (skipped lines count), and it must hold at least one network.

A network is an address, or an address followed by `/` and a prefix length.

- An address is four numbers separated by `.`. Each number is `0` or one to three digits without a leading zero, at most 255. `01` and `256` are bad.
- A prefix length is `0` or one or two digits without a leading zero, at most 32. `33`, `033`, `-1` and an empty text are bad.
- An address without `/` is a network of one address (prefix length 32).
- Host bits are set when the address is not the first address of the network: `10.0.0.1/24` has host bits set and is rejected, `10.0.0.0/24` is fine. A prefix length of 32 never has host bits.

## Styles

Every network is written in one of four styles:

- `cidr`: address, `/` and length, for example `10.0.0.0/8`, or `1.2.3.4/32` for one address.
- `range`: first and last address, for example `10.0.0.0-10.255.255.255`.
- `mask`: first address, a space and the dotted netmask, for example `10.0.0.0 255.0.0.0`.
- `hex`: the first address as eight upper-case hexadecimal digits, `/` and the length, for example `0A000000/8` or `C0A80100/24`.

## Output

A command that works writes its result to standard output and nothing to standard error. Counts use the singular for 1 (`1 network`) and the plural otherwise (`3 networks`).

- `check` prints `ok, N networks`, counting only the networks (skipped lines do not count).
- `sort` prints every network, ordered by first address and then by prefix length (shorter first), one per line in the chosen style.
- `merge` prints the fewest networks that cover exactly the addresses of the list, ordered by first address. Networks that overlap or touch are joined first; neighbours that do not form one network stay separate, so `10.0.0.128/25` and `10.0.1.0/25` stay two networks.
- `count` prints the number of covered addresses, each counted once. With `--mode hosts` it takes the merged networks and counts each one's addresses minus 2 when its prefix length is 30 or shorter, and all its addresses for length 31 or 32.
- `gaps` prints the addresses of the `--within` network that no listed network covers, as the fewest networks ordered by first address. Networks outside it are ignored, and one that sticks out covers only the part inside. When nothing is left it prints `none`.
- `contains` prints one line `IP in NET` for every listed network, in input order, that holds the address (NET in `cidr` style). If none does, it prints `IP is not covered` on standard output and exits 1.
- `split` prints every network in input order, cut into networks of the given prefix length in ascending order. A network that already has that length stays as it is.

## Examples

In the examples, `cidrlist` stands for a shell function that runs `escript cidrlist "$@"`. They use a POSIX shell in the repository directory; `2>&1` shows the error line.

```text
$ printf '10.0.0.0/25\n10.0.0.128/25\n10.0.1.0/24\n' | cidrlist merge
10.0.0.0/23
$ printf '10.0.0.0/24\n192.168.1.0/30\n' | cidrlist sort --style range; printf '172.16.0.0/12\n' | cidrlist sort --style mask
10.0.0.0-10.0.0.255
192.168.1.0-192.168.1.3
172.16.0.0 255.240.0.0
$ printf '10.0.0.0/24\n10.0.0.64/26\n' | cidrlist gaps --within 10.0.0.0/23; printf '10.0.0.0/30\n' | cidrlist split --prefix 31 --style hex
10.0.1.0/24
0A000000/31
0A000002/31
$ printf '10.0.0.0/8\n10.0.0.1/24\n' | cidrlist check 2>&1; printf '10.0.0.0/8\n' | cidrlist contains 2>&1
cidrlist: line 2: host bits set 10.0.0.1/24
cidrlist: missing --ip
```

## Errors

A command that fails writes nothing to standard output and one line `cidrlist: MESSAGE` to standard error.

Exit statuses:

- 0: success, including help and `--version`.
- 1: an error in the list or in a command, and `contains` when no network holds the address.
- 2: an error in the command line, or no arguments at all. The input is not read then.

Command line errors (exit 2), checked left to right with the first problem reported:

- `cidrlist: unknown command WORD`
- `cidrlist: unexpected argument WORD` (a word that does not start with `-`, or is exactly `-` or empty)
- `cidrlist: unknown option WORD`
- `cidrlist: option OPTION is not valid for COMMAND`
- `cidrlist: given twice: OPTION`
- `cidrlist: missing value for OPTION`
- `cidrlist: bad value for OPTION`
- `cidrlist: missing --within`, `cidrlist: missing --ip`, `cidrlist: missing --prefix`

List errors (exit 1), the first problem in line order:

- `cidrlist: input is too long (max 40 lines)`
- `cidrlist: line N: expected 1 network`
- `cidrlist: line N: bad network WORD`
- `cidrlist: line N: host bits set WORD`
- `cidrlist: no networks`

Command errors (exit 1), from `split`:

- `cidrlist: line L: cannot split WORD into /N`
- `cidrlist: too many subnets (max 256)`

Line numbers count from 1 and include skipped lines.

## Development

The project needs Elixir 1.15 or newer and runs on Windows, macOS and Linux. Before you commit, these must pass:

```text
mix format --check-formatted
mix compile --warnings-as-errors
mix test
```

The project is released under the MIT license (see the `LICENSE` file).

---

Built with [BAKED](https://github.com/Gulliby-development/baked), an open-source coding agent (bench round R105).
