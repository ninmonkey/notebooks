// file:///H:\data\2023\pwsh\notebooks\js\dates\Compare%20Date%20Ctor%20args.js
// about: comparing Date() Ctors, showing unexpected values
// some of the code is weird, because it's meant for an interactive "Qoukka.js" notebook

// test 1: as integers
let d0 = new Date(2020, 1, 1) // feb  1 2020
d0;
d0 = new Date(2020, 0, 1) // jan  1 2020
d0;
d0 = new Date(2020, 0, 0) // dec 31 2019
d0;
d0 = new Date(2020, 1, 0) // jan 31 2020
d0;

let samples_0 = [
    { y: 2020, m: 1, d: 1 }, // feb  1 2020
    { y: 2020, m: 0, d: 0 }, // feb  1 2020
    { y: 2020, m: 0, d: 1 }, // feb  1 2020
    { y: 2020, m: 1, d: 0 }, // feb  1 2020
    { y: 2020, m: '1', d: '1' },
    { y: 2020, m: '0', d: '0' },
    { y: 2020, m: '0', d: '1' },
    { y: 2020, m: '1', d: '0' },
]
let summary_a = Array.from([])
samples_0.forEach(
    (o) => {
        const one = new Date( o.y, o.m, o.d )
        summary_a.push( {
            y: one.getFullYear(),
            m: one.getMonth(),
            d: one.getDate(),
            result: one
        } )
    }
)

// summary_a;

q = summary_a[0]
q;

q = summary_a[1]
q;

let cult = new Intl.DateTimeFormat('en-us')
let cultName = 'en-us'
let samples = [
    { y: 2020, m: 1, d: 1 }, // feb  1 2020
    { y: 2020, m: 0, d: 1 }, // feb  1 2020
]
let summary = Array.from([])
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

const arr = [{
  key: "11",
  value: "1100"
}, {
  key: "22",
  value: "2200"
}];
const object = arr.reduce((obj, item) => ({
  ...obj,
  [item.key]: item.value
}), {});
console.log(object)

arr.reduce( (obj, item) => {
    obj[ item.key ] = item.value
    return obj
}, {} )

arr.reduce( (obj, item) => {
    obj[ item.key ] = item.value
    return obj
}, {} )

arr;
// function intlPartsToObject {

// }
hash = {}
parts.map((o) => hash[ o.type ] = o.value )

samples.forEach(
    (o) => {
        const dtObj = new Date( o.y, o.m, o.d )
        summary.push( {
            param_y: o.y,
            param_m: o.m,
            param_d: o.d,
            obj_y: dtObj.getFullYear(),
            obj_m: dtObj.getMonth(),
            obj_d: dtObj.getDate(),
            // result: dtObj,
            // fmt: formatToParts( dtObj )
        } )
    }
)



// summary;

q = summary[0]
q;

q = summary[1]
q;

dive = summary[0].obj_
dive;
