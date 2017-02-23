defmodule Twinder.Coordinator do

  def loop(results \\ [], results_expected) do
    receive do
      {:ok, result} ->
        new_results = [ results | result ]
        cond do
          Enum.count(new_results) == results_expected ->
            send self(), :exit
          true ->
            loop(new_results, results_expected)
        end
      :end ->
        results
    end
  end

end
