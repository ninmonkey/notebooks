// test 1: as integers

let d0 = new Date(2020, 1, 1) // feb  1 2020
d0;
d0 = new Date(2020, 0, 1) // jan  1 2020
d0;
d0 = new Date(2020, 0, 0) // dec 31 2019
d0;
d0 = new Date(2020, 1, 0) // jan 31 2020
d0;

let samples = [
    { y: 2020, m: 1, d: 1 }, // feb  1 2020
    { y: 2020, m: 0, d: 1 }, // feb  1 2020
]
let summary = Array.from([])
samples.forEach(
    (o) => {
        const one = new Date( o.y, o.m, o.d )
        summary.push( {
            y: one.getFullYear(),
            m: one.getMonth(),
            d: one.getDate(),
            result: one
        } )
    }
)

// summary;

q = summary[0]
q;

q = summary[1]
q;

