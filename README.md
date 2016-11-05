[![CircleCI](https://circleci.com/gh/eduardonunesp/pinger.svg?style=svg)](https://circleci.com/gh/eduardonunesp/pinger)

# Pinger

Pinger is an application to help you to monitoring your HTTP endpoints, like a health check. Pinger creates and supervises HTTP requests, also Pinger checks targets URLs on an configured interval. We call targets, you can add many targets as you wish to keep checking and acting when needed.

## Instalation

Add Pinger to your project's dependencies in `mix.exs`

```Elixir
  defp deps do
    [
      {:pinger, "~> 0.1.0"}
    ]
  end

  def application do
    [ applications: [:pinger] ]
  end
```

And fetch your project's dependencies:

```
$ mix deps.get
```

