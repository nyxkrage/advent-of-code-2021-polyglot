// Learn more about F# at http://docs.microsoft.com/dotnet/fsharp

open System
open System.IO

let TransformInput (input: string) = 
    let words = input.Split(' ');
    (words.[0], words.[1])

let ReduceInstructions acc value =
    let (distance, depth, aim) = acc;
    let (forward, vertical,_) = value;
    let newAim = aim + vertical;

    (distance + forward, forward * newAim + depth, newAim)

let part1 input =
    let (f,d) = input |> Seq.reduce (fun a b -> (fst a + fst b, snd a + snd b));
    f * d

let part2 input =
    let (f,d,_) = input |> Seq.map (fun a -> (fst a, snd a, 0)) |> Seq.reduce ReduceInstructions;
    f * d

[<EntryPoint>]
let main argv =
    let input = File.ReadAllText("input").Split("\n") |> Seq.map TransformInput |> Seq.map (fun ((command, value): string*string) -> 
        match command with
            | "forward" -> (value |> int, 0)
            | "down" -> (0, value |> int)
            | "up" -> (0, -(value |> int))
        );
    let result1 = input |> part1;
    let result2 = input |> part2;

    printf "%d\n" result1;
    printf "%d\n" result2;
    0 // return an integer exit code
