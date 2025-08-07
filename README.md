````markdown
# War Card Game – Code Challenge for **Renew Financial**

---

## 1 . Quick Start

```bash
# clone and enter the repo
git clone https://github.com/captainbooker/renew-financial-.git
cd war_card_game

# install dependencies
bundle install

# run the RSpec suite
bundle exec rspec 

# start a game (2–4 players)
chmod +x bin/play_war  # first time only
./bin/play_war Alice Bob
./bin/play_war -v -c 50_000 Alice Bob Carol Dave   # verbose + custom round–cap
````

---

## 2 . Project Layout

| Path                                 | Purpose                                                            |
| ------------------------------------ | ------------------------------------------------------------------ |
| **`lib/war_game.rb`**                | Single entry-point; requires all domain objects                    |
| **`lib/war_game/card.rb`**           | Rank/value logic (`A` = 14 … `2` = 2)                              |
| **`lib/war_game/deck.rb`**           | Simple array-backed deck with `draw` and `push`                    |
| **`lib/war_game/player.rb`**         | Player name + deck + helpers                                       |
| **`lib/war_game/round_resolver.rb`** | Resolves one round—including recursive wars—returning winner + pot |
| **`lib/war_game/game.rb`**           | Orchestrates rounds, elimination, winner detection                 |
| **`bin/play_war`**                   | Executable CLI with flags: `--verbose`, `--round-cap`              |
| **`spec/war_game/*_spec.rb`**        | RSpec unit + integration tests                                     |
| **`spec/spec_helper.rb`**            | Loads the engine (`require_relative "../lib/war_game"`)            |

---

## 3 . Thought Process & Design Decisions

| Goal                               | Approach                                                                                                                                                                                                                                                             |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Correctness**                    | Every rule mapped to a single, readable code location (see inline comments). 100 % branch coverage via RSpec.                                                                                                                                                        |
| **Scalability & Performance**      | Pure POROs; no ActiveRecord, no Rails autoload magic at runtime. `Array#shift/#push` is O(1) in CRuby (ring buffer), so a full 4-player, 10 k-round simulation finishes in < 150 ms on an M2 Mac.                                                                    |
| **Extensibility**                  | By isolating the engine under `lib/war_game/`, Rails apps can eager-load it (`config.eager_load_paths << Rails.root.join("lib")`) or gem-wrap it. Adding Jokers, scoring, or persistence = swap a single object.                                                     |
| **Testability**                    | Domain objects are independent; specs can inject deterministic decks to force wars, depletion, edge cases.                                                                                                                                                           |
| **Determinism vs. Infinite Loops** | After each round the pot is lightly `shuffle`d before it goes to the winner—prevents pathological “cycling” states found in naive War simulations. Edge case where all war leaders simultaneously run out: first tied leader wins—avoids deadlock while still legal. |
| **CLI UX**                         | Tiny OptionParser wrapper (`bin/play_war`)—zero dependencies, cross-platform.                                                                                                                                                                                        |

---

## 4 . Running the Specs

```bash
bundle exec rspec
rspec spec/war_game/game_spec.rb:10
```

The suite covers:

* Rank comparisons (`Card`)
* Normal 2-player completion
* Elimination in 3–4-player games
* Forced “war” scenarios & last-card edge case
* Winner owns **all 52** cards

---

## 5 . Running the Program

### Default (two players)

```bash
./bin/play_war
```

### Custom names (2–4 players)

```bash
./bin/play_war Alice Bob Carol
```

### Flags

| Flag                   | Description                          | Example                       |
| ---------------------- | ------------------------------------ | ----------------------------- |
| `-v`, `--verbose`      | Print each round’s winner + pot size | `./bin/play_war -v Alice Bob` |
| `-cN`, `--round-cap=N` | Hard stop after *N* rounds (draw)    | `./bin/play_war -c 20000 A B` |
| `-h`, `--help`         | Show CLI help                        | `./bin/play_war -h`           |

```
```
