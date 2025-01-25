module Utils

    function write_text(data, path)
        open(path, "a") do f
            for line in data
                print(f, line)
                print(f, ",\t")
            end
            print(f, "\n")
        end
        return nothing
    end

    function read_text(path)
        data = []
        open(path) do f
            for line in eachline(f)
                line = split(line, ",\t")
                tmp_data = [NaN, NaN]
                tmp_data[1] = parse(Float64, line[1])
                tmp_data[2] = parse(Float64, line[2])
                push!(data, tmp_data)
            end
        end
        return data
    end

end