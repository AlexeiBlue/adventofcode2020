use regex::Regex;

fn main() {
    let input = fs::read_to_string("./puzzle4[input]").expect("Something went wrong reading the file");

    let byr_re = Regex::new("byr:(\\d{4})\\b").unwrap();
    let iyr_re = Regex::new("iyr:(\\d{4})\\b").unwrap();
    let eyr_re = Regex::new("eyr:(\\d{4})\\b").unwrap();
    let hgt_cm_re = Regex::new("hgt:(\\d{3})cm\\b").unwrap();
    let hgt_in_re = Regex::new("hgt:(\\d{2})in\\b").unwrap();
    let hcl_re = Regex::new("hcl:#[a-f\\d]{6}\\b").unwrap();
    let ecl_re = Regex::new("ecl:amb|blu|brn|gry|grn|hzl|oth\\b").unwrap();
    let pid_re = Regex::new("pid:\\d{9}\\b").unwrap();
    
    let mut valid = 0;
    for line in input.split("\n\n") {
        if line.contains("byr:") 
            && line.contains("iyr:") 
            && line.contains("eyr:") 
            && line.contains("hgt:") 
            && line.contains("hcl:") 
            && line.contains("ecl:")  
            && line.contains("pid:") {
            
            let byr = byr_re.captures(line).unwrap().get(1).map_or("0", |m| m.as_str()).parse::<i32>().unwrap();
            let iyr = iyr_re.captures(line).unwrap().get(1).map_or("0", |m| m.as_str()).parse::<i32>().unwrap();
            let eyr = eyr_re.captures(line).unwrap().get(1).map_or("0", |m| m.as_str()).parse::<i32>().unwrap();
            let hgt_cm = if hgt_cm_re.is_match(line) { hgt_cm_re.captures(line).unwrap().get(1).map_or("0", |m| m.as_str()).parse::<i32>().unwrap() } else { 0 };
            let hgt_in = if hgt_in_re.is_match(line) { hgt_in_re.captures(line).unwrap().get(1).map_or("0", |m| m.as_str()).parse::<i32>().unwrap() } else { 0 };
        
            if byr >= 1920 && byr <= 2002
                && iyr >= 2010 && iyr <= 2020
                && eyr >= 2020 && eyr <= 2030
                && ((hgt_cm >= 150 && hgt_cm <= 193) || (hgt_in >= 59 && hgt_in <= 76))
                && hcl_re.is_match(line)
                && ecl_re.is_match(line)
                && pid_re.is_match(line) {
                //{'pid': '3966920279', 'hgt': '161cm', 'ecl': 'gry', 'byr': '1997', 'eyr': '2027', 'iyr': '2015', 'hcl': '#cfa07d'}
                valid = valid + 1;
            }
        }
    }
    
    println!("Valid Passports {}", valid);
}
