defmodule Credo.Check.Refactor.PipeChainStartTest do
  use Credo.TestHelper

  @described_check Credo.Check.Refactor.PipeChainStart

  test "it should NOT report expected code" do
~S"""
defmodule CredoSampleModule do
  def some_function(parameter1, parameter2) do
    "Fahrenheit 451" |> String.to_char_list |> IO.inspect

    "Fahrenheit 451" |> String.strip

    do_something() |> then_something_else() |> and_last_step()

    something
    |> String.downcase
    |> String.strip

    :something
    |> is_atom
    |> &(&1)

    FooBar
    |> to_string

    map[:something]
    |> is_atom
    |> IO.inspect

    1..100
    |> IO.inspect

    ?@..@some_value
    |> IO.inspect


    bar = [3, 2, 1]
    |> tl
    |> Enum.join

    map.key
    |> Enum.map(&String.upcase/1)
    |> Enum.join

    %Bar{}
    |> something()
    |> IO.inspect

    %{} |> something()

    %{"foo" => :bar}
    |> something()
    |> IO.inspect

    %{foo: :bar}
    |> something()
    |> IO.inspect

    {}
    |> Module.something()

    {:ok, foobar, 42}
    |> Module.something()
    |> something_else

    ~r/\d+\s\z/
    |> Regex.run(string)

    ~w(foo bar baz)a
    |> Enum.map(&to_string/1)
    |> Enum.join

    ~s(qick brown fox)
    |> String.upcase
    |> IO.inspect

    @something
    |> Enum.map(&String.upcase/1)
    |> Enum.join

    @something
    |> Enum.map(&String.upcase/1)
    |> Enum.join

    "A #{baked_good}" |> String.upcase |> IO.inspect

    << thing::utf8 >> |> String.upcase |> IO.inspect

    quote do
      unquote(foo)
      |> bar
    end
  end
end
""" |> to_source_file
    |> refute_issues(@described_check)
  end




  test "it should report a violation for a function call" do
"""
String.strip("nope") |> String.upcase
String.strip("nope")
|> String.downcase
|> String.strip
""" |> to_source_file
    |> assert_issues(@described_check)
  end

  test "it should report a violation for a function call 2" do
"""
fun([a, b, c])
|> something1
|> something2
|> something3
|> IO.inspect
""" |> to_source_file
    |> assert_issue(@described_check)
  end

  test "it should report a violation for a function call 3" do
"""
fun.([a, b, c]) |> IO.inspect
fun.([a, b, c]) |> Enum.join |> IO.inspect
fun.([a, b, c])
|> Enum.join
|> IO.inspect
""" |> to_source_file
    |> assert_issues(@described_check)
  end

end
