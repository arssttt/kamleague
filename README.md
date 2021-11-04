# KaM League

KaM League is a competetive league for the Knights and Merchants Remake strategy game. It is written in Elixir using the Phoenix Framework. The goal is to provide an open source, community involved league for KaM Remake, and provide the players with an option to play competetive games.

## Installation

The following packages are required to build KaM League:

* Elixir >= 1.9
* npm >= 6.13.4
* PostgreSQL
* python2

Run the following commands:

```bash
git clone git@github.com:isacsund/kamleague.git
cd kamleague
mix deps.get
mix ecto.setup
cd assets && npm install
mix phx.server
```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Contributing

KaM League is completely open source; community involvement is highly encouraged. If you wish to contribute ideas or code, please make a pull request to our [Github repository](https://github.com/isacsund/kamleague/pulls).

## License

[MIT](LICENSE)
