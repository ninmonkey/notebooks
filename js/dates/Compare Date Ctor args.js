// file:///H:\data\2023\pwsh\notebooks\js\dates\Compare%20Date%20Ctor%20args.js
// about: comparing Date() Ctors, showing unexpected values
// some of the code is weird, because it's meant for an interactive "Qoukka.js" notebook

// test 1: as integers
const now = new Date()
let d0 = new Date(2020, 1, 1) // feb  1 2020
let _ = d0;
d0;
d0 = new Date(2020, 0, 1) // jan  1 2020
d0;
d0 = new Date(2020, 0, 0) // dec 31 2019
d0;
d0 = new Date(2020, 1, 0) // jan 31 2020
d0;

let cultName = 'en-us'
let cult = new Intl.DateTimeFormat( cultName )
_ = cult.formatToParts( now )
_;
_ = _[0]
_;

let samples = [
    { y: 2020, m: 1, d: 1 }, // feb  1 2020
    { y: 2020, m: 0, d: 0 }, // feb  1 2020
    { y: 2020, m: 0, d: 1 }, // feb  1 2020
    { y: 2020, m: 1, d: 0 }, // feb  1 2020
    { y: 2020, m: '1', d: '1' },
    { y: 2020, m: '0', d: '0' },
    { y: 2020, m: '0', d: '1' },
    { y: 2020, m: '1', d: '0' },
]
let summary = Array.from([])
samples.forEach(
    (o) => {
        const one = new Date( o.y, o.m, o.d )
        summary.push( {
            y: o.y,
            m: o.m,
            d: o.d,
            obj_y: one.getFullYear(),
            obj_m: one.getMonth(),
            obj_d: one.getDate(),
            result: one
        } )
    }
)

// summary;

_ = summary[0]
_
_ = summary[1]
_
q = summary[1]
q;



function formatToParts( dateObj, options ) {
    const cultDefaults = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' }
    options = {
        ...cultDefaults,
        ...options
    }
    const cult = new Intl.DateTimeFormat( cultName, options  )
    return cult.formatToParts( dateObj )
}


// let parts = cultInfo.formatToParts( new  Date(2000, 1, 3))

_ = summary[0]
_
_ = summary[1]
_

dive = summary[0]
dive;
