defmodule H do
  def sx(x) do
      elem(List.first(x),0)
  end

  def sy(x) do
    elem(List.first(x),1)
  end

  def ex(x) do
    elem(List.last(x),0)
  end

  def ey(x) do
    elem(List.last(x),1)
  end

  def formula(e) do
    {
      H.sx(e) > H.ex(e),
      H.sy(e) > H.ey(e),
      abs(H.sx(e) - H.ex(e))
    }
  end

  def calc(f, e, i) do
    {
      if(elem(f,0), do: sx(e) - i, else: sx(e) + i),
      if(elem(f,1), do: sy(e) - i, else: sy(e) + i)
    }
  end
end


content = String.split(File.read!("input"), "\n")
coordinates = Enum.map(content, fn x -> String.split(x, " -> ") |> Enum.map(fn y -> String.split(y, ",") |> Enum.map(fn z -> String.to_integer(z) end) |> List.to_tuple() end) end)
part1 = coordinates |> Enum.filter(fn x -> H.sx(x) == H.ex(x) || H.sy(x) == H.ey(x) end)
lines = part1 |> Enum.map(fn x -> if(H.sx(x)==H.ex(x), do: Enum.map(H.sy(x)..H.ey(x), fn y -> {H.sx(x),y} end), else: Enum.map(H.sx(x)..H.ex(x), fn y -> {y,H.sy(x)} end)) end)
# Part 2
part2 = coordinates |> Enum.filter(fn x -> H.sx(x) != H.ex(x) && H.sy(x) != H.ey(x) end)
tiles = part2 |> Enum.map(fn e -> Enum.map(0..(elem(H.formula(e),2)), fn i -> H.calc(H.formula(e), e, i) end) end) |> Enum.concat(lines) |> List.flatten()

danger = tiles |> Enum.frequencies() |> Map.to_list() |> Enum.count(fn x -> elem(x,1) >= 2 end)
IO.inspect(danger)
