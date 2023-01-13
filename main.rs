/*
Intellectual property information START

Copyright (c) 2023 Ivan Bityutskiy

Permission to use, copy, modify, and distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Intellectual property information END


Description START

The program produces 27 unique passwords with user defined length (1..=85).

Description END
*/

use std::io;
use std::io::Write;
use rand::Rng;

fn main()
{
    // Declare variables START
    // Request password's length from the user
    let mut user_input: String = String::new();
    print!("\nEnter password's length (1..=85): ");
    // Flush the STDOUT to place prompt on the same line as the request
    io::stdout().flush().unwrap();
    io::stdin().read_line(&mut user_input).expect("Number 1..=85");

    // If the answer is NaN, or can't be casted into usize, set it to 85
    let mut pass_length: usize = user_input.trim().parse().unwrap_or(85);
    // If the answer can be casted into usize, make sure it's in 1..=85 range
    if (pass_length < 1) || (pass_length > 85)
    {
        pass_length = 85;
    }

    // Array with all the symbols allowed in passwords
    // Any char has fixed size of 4 bytes, using strings (1 byte) instead of chars
    let symbols: [&str; 85] = [
        "#",
        "$",
        "%",
        "&",
        "(",
        ")",
        "*",
        "+",
        "-",
        ".",
        "0",
        "1",
        "2",
        "3",
        "4",
        "5",
        "6",
        "7",
        "8",
        "9",
        ":",
        ";",
        "=",
        ">",
        "?",
        "@",
        "A",
        "B",
        "C",
        "D",
        "E",
        "F",
        "G",
        "H",
        "I",
        "J",
        "K",
        "L",
        "M",
        "N",
        "O",
        "P",
        "Q",
        "R",
        "S",
        "T",
        "U",
        "V",
        "W",
        "X",
        "Y",
        "Z",
        "[",
        "]",
        "^",
        "_",
        "a",
        "b",
        "c",
        "d",
        "e",
        "f",
        "g",
        "h",
        "i",
        "j",
        "k",
        "l",
        "m",
        "n",
        "o",
        "p",
        "q",
        "r",
        "s",
        "t",
        "u",
        "v",
        "w",
        "x",
        "y",
        "z",
        "{",
        "|",
        "}"
    ];

    // String to store the password
    let mut pass_str: String = String::new();
    // Auxiliary string to help with the password generation
    let mut aux_string: &str;
    // u8: 0..=255
    let mut counter: u8 = 0;
    // Declare variables END

    // println!("\x1B[1;1H\x1B[0J");
    println!("");
    // Produce 27 lines with unique password on each line
    while counter < 27
    {
        // Compate the length of password string to desired password length
        while pass_str.len() < pass_length
        {
            // Get random symbol from the array
            aux_string = &symbols[rand::thread_rng().gen_range(0..85)];
            // Check if symbol is present in password string to avoid duplicates
            match pass_str.find(aux_string)
            {
                Some(_) => continue,
                None => pass_str.push_str(aux_string)
            }
        }
        // Display full password string to the user
        println!("{}", pass_str);
        // Clear password string to use in next iteration of while loop
        pass_str.clear();
        // Raise up the counter for the outer loop
        counter += 1;
    }
    println!("");
}
// END OF PROGRAM

