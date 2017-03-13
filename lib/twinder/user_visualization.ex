defmodule Twinder.User.Visualization do
  alias Graphvix.{Graph, Node, Edge, Cluster}

  def show_interactions(interactions) do
    Graph.new(:interactions)
    graph_names = interactions
    |> Enum.map(fn {u1, _, u2} -> [u1, u2] end)
    |> Enum.flat_map(&(&1))
    |> Enum.uniq

    graph_nodes = graph_names
    |> Enum.map(&({&1, Node.new(label: &1)}))

    interactions
    |> create_graph_with_nodes(graph_nodes)

    Graph.save
    Graph.compile(:png)
  end

  defp create_graph_with_nodes(interactions, graph_nodes) do
    interactions
    |> Enum.each(fn {u1, _interaction, u2} ->
      {_, {node1_id, _node}} = graph_nodes |> Enum.find(fn {u, _} -> u == u1 end)
      {_, {node2_id, _node}} = graph_nodes |> Enum.find(fn {u, _} -> u == u2 end)
      {_edge_id, _edge} = Edge.new(node1_id, node2_id)
    end)
  end

end
