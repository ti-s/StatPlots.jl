
# ---------------------------------------------------------------------------
# density

@recipe function f(::Type{Val{:density}}, x, y, z; trim=false)
    newx, newy = violin_coords(y, trim=trim)
    if Plots.isvertical(d)
        newx, newy = newy, newx
    end
    x := newx
    y := newy
    seriestype := :path
    ()
end
Plots.@deps density path


# ---------------------------------------------------------------------------
# cumulative density

@recipe function f(::Type{Val{:cdensity}}, x, y, z; trim=false,
                   npoints = 200)
    newx, newy = violin_coords(y, trim=trim)

    if Plots.isvertical(d)
        newx, newy = newy, newx
    end

    newy = [sum(newy[1:i]) for i = 1:length(newy)] / sum(newy)

    x := newx
    y := newy
    seriestype := :path
    ()
end
Plots.@deps cdensity path

# ---------------------------------------------------------------------------
# StatsBase.Histogram

@recipe function f(h::StatsBase.Histogram)
    seriestype := :bar
    h.edges[1], h.weights
end
