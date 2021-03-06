@userplot GroupedBar

grouped_xy(x::AbstractVector, y::AbstractMatrix) = x, y
grouped_xy(y::AbstractMatrix) = 1:size(y,1), y

@recipe function f(g::GroupedBar)
    x, y = grouped_xy(g.args...)

    nr, nc = size(y)
    isstack = pop!(d, :bar_position, :dodge) == :stack

    # extract xnums and set default bar width.
    # might need to set xticks as well
    xnums = if eltype(x) <: Number
        bar_width --> (0.8 * mean(diff(x)))
        x
    else
        bar_width --> 0.8
        ux = unique(x)
        xnums = (1:length(ux)) - 0.5
        xticks --> (xnums, ux)
        xnums
    end
    @assert length(xnums) == nr

    # compute the x centers.  for dodge, make a matrix for each column
    x = if isstack
        x
    else
        bws = d[:bar_width] / nc
        bar_width := bws
        xmat = zeros(nr,nc)
        for r=1:nr
            bw = cycle(bws, r)
            farleft = xnums[r] - 0.5 * (bw * nc)
            for c=1:nc
                xmat[r,c] = farleft + 0.5bw + (c-1)*bw
            end
        end
        xmat
    end

    # compute fillrange
    fillrange := if isstack
        # shift y/fillrange up
        y = copy(y)
        fr = zeros(nr, nc)
        for c=2:nc
            for r=1:nr
                fr[r,c] = y[r,c-1]
                y[r,c] += fr[r,c]
            end
        end
        fr
    else
        get(d, :fillrange, nothing)
    end

    seriestype := :bar
    x, y
end
