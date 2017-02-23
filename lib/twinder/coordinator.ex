defmodule Twinder.Coordinator do

  def loop(results \\ [], results_expected) do
    receive do
      {:ok, result} ->
        new_results = results ++ [result]
        if Enum.count(new_results) == results_expected do
          send self(), :exit
        end
        loop(new_results, results_expected)
      :exit ->
        IO.puts "Results:"
        IO.inspect results
      _ ->
        loop(results, results_expected)
    end
  end

end
