let read_whole_file filename =
    let ch = open_in filename in
    let s = really_input_string ch (in_channel_length ch) in
    close_in ch;
    s;;

let rec fold f l acc =
    match l with
        [] -> acc
        | h::t -> f h (fold f t acc);;

let sum l = fold (fun x y -> x+y) l 0;;

let med l =
    let asc = List.sort compare l in
    List.nth asc (((List.length asc) + 1) / 2);;

let avg l =
    Float.to_int (float_of_int (sum l) /. float_of_int (List.length l));;

let nums = List.map (int_of_string) (String.split_on_char ',' (read_whole_file "input"));;

let print_int_nl i =
    print_int i;
    print_string "\n";;

let s = med nums;;
let sfuel = List.map (fun x -> abs(x - s)) nums;;
print_int_nl (sum sfuel);;

let a = avg nums;;
let afuel = List.map (fun x -> let n = abs(a - x) in n * (n+1)/2) nums;;
print_int_nl (sum afuel);;
