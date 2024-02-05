// file:///H:\data\2023\pwsh\notebooks\js\dates\Compare%20Date%20Ctor%20args.js
// about: comparing Date() Ctors, showing unexpected values
// some of the code is weird, because it's meant for an interactive "Qoukka.js" notebook
// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date
// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl
/*

JavaScript specification only specifies one format to be universally supported: the date time string format, a simplification of the ISO 8601 calendar date extended format. The format is as follows:

YYYY-MM-DDTHH:mm:ss.sssZ


*/

// test 1: as integers
const now = new Date()
let d0 = new Date(2020, 1, 1) // feb  1 2020
let _ = d0;

_ = now.toDateString()
_
_ = now.toISOString()
_
_ = now.toJSON()
_
_ = now.toLocaleDateString()
_
_ = now.toLocaleString()
_
_ = now.toLocaleTimeString()
_
_ = now.toString()
_
_ = now.toTimeString()
_
_ = now.toUTCString()
_


_
_ = now.toString()
_
_ = now.toString()
_


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
