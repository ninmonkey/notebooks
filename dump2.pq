let
    findMaxOverlapSpan = (A as record, B as record) as list =>
        [Start = if A[Start] < B[Start] then A[Start] else B[Start], End = if A[End] > B[End] then A[End] else B[End]],
    isOverlapping = (A as record, B as record) as logical => (A[Start] < B[End]) and (B[Start] < A[End]),
    // Given some record of the form [Start = number, End = number], a list of records of the same form, and an empty record,
    // calculate the maximum allowed span of time with base as the base record,
    // and return the combined overlap and which entries were used to create it.
    mergeSpan = (base as record, toExamine as list, partial as record) as record =>
        let
            listLength = List.Count(toExamine)
        in
            if listLength = 0 then
                partial & [Result = base]
            else
                let
                    head = toExamine{0}, tail = List.RemoveFirstN(toExamine, 1)
                in
                    if isOverlapping(base, head) then
                        let
                            newBase = findMaxOverlapSpan(base, head),
                            newPartial = partial & [Removed = partial[Removed]? ?? {} & {head}]
                        in
                            @mergeSpan(newBase, tail, newPartial)
                    else
                        @mergeSpan(base, tail, partial),
    flattenSpans = (activeDurations as list, exhaustedDurations as list) as list =>
        let
            listLength = List.Count(activeDurations)
        in
            if listLength = 0 then
                exhaustedDurations
            else if listLength = 1 then
                activeDurations & exhaustedDurations
            else
                let
                    head = activeDurations{0},
                    tail = List.RemoveFirstN(activeDurations, 1),
                    partialSum = mergeSpan(head, tail, []),
                    newExhausted = exhaustedDurations & partialSum[Removed] & {partialSum[Result]},
                    newActive = List.Difference(tail, partialSum[Removed])
                in
                    @flattenSpans(newActive, newExhausted)
in
    flattenSpans(listOfStartEnd, {})