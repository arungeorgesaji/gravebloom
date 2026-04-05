local M = {}
 
function M.lerpN(a, b, t)
    return a + (b - a) * t
end
 
function M.lerpColor(a, b, t)
    return {
        M.lerpN(a[1], b[1], t),
        M.lerpN(a[2], b[2], t),
        M.lerpN(a[3], b[3], t)
    }
end
 
function M.easeInOut(t)
    return t < 0.5 and 2 * t * t or 1 - math.pow(-2 * t + 2, 2) / 2
end
 
return M
