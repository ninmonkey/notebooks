> but my brain works different when I'm writing
You're totally right, your brain processes things differently. There's a name for that, called <https://en.wikipedia.org/wiki/Rubber_duck_debugging> . Or when you find the answer to something right after asking discord

@Venom-Host#5966 One style of development is called test-driven. Basically you write step 1 of creating a user, then write a test for that. Write step2, and a test for that.  What's nice about that is it run tests *every* time. You make changes. Some projects that makes sense, other cases may have things that are not practical. 

With pester, sometimes making sure a thing never error is useful. Maybe Get-UserName should only return string, or null. But in this case it threw an exception, so something broke.
```ps1
{ Get-UserName 'abc2134' } | Should -Never -Throw -Because 'UserName should never fail'
```
Say the business logic promises you user's Employee Id will always be a distinct (ie: no duplicate values).
it's guaranteed. HR's data entry actually enforces that.   Then, the company merges, so everyone now has a Employee Id and Company Id.
- the Id's end up Colliding because the software only enforces unique values in the current company
- and Managers have to be entered into payroll on multiple companies, so there are employee ids that should be duplicate

A little test like this caught it. And it's a bit of self-documenting code, it shows what initial assumptions where when the function was written. ( Because things that can't ever happen, end up happening )
```ps1
$users = Get-AlLUsers
($users | Group-Object EmployeeId | ? Count -gt 1).count
| Should -be 0 -because 'UserId was promised to be a Guid'
````

> google at copy someone else code

It sounds like you've got a good attitude for wanting to learn. Something to think about
1] Knowing how to find out how to do something is more important than knowing how to do something -- if that makes sense. Tech is always changing, so it's big there. 

Although people deride googling, but know how to google something is a skill.

2] re-inventing the wheel can be useful for learning, but 

> often wheels are good at being wheels

3] There's a thing called imposters syndrome, it's super common among programmers,
If that's something that affects you (Like me),
just remember: Everyone has a different Journey, a different history. Comparing yourself to others isn't necessarily fair to oneself. Try framing it as an inspiration, instead of judgement. I tried finding a specific video from <https://www.youtube.com/@GuyInACube> , he talked about that idea, far more eloquent. 

4] Also don't be afraid to be wrong. I remember sitting in physics lectures where there was a new concept and they'd ask what the answer was. If I commited to an answer -- even the wrong one -- I found that it was easier to learn. 




 For myself, even today I don't publish a bunch of code that I should


which I think is even more amplified with the internet.


 Even when someone has 20+ years experience -- they don't know everything. It's just too vast for one person. 




