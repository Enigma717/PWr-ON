# Marek Traczyński (261748)
# Obliczenia Naukowe
# Lista 5
# 
# Test złożoności czasowej


include("./iointerface.jl")
include("./matrixgen.jl")
using Plots
using .matrixgen 


# Aliasy długich typów
const READ_MATRIX_TYPE = Tuple{Int, Int, Vector{Tuple{Int, Int, Float64}}}
const READ_VECTOR_TYPE = Tuple{Int, Vector{Float64}}

# Ścieżki do folderu z wejściem/wyjściem
const DATA_DIR::String = "./data"
const TESTSRESULT_DIR::String = "./testresults"

# Parametry generowanej macierzy
const BLOCK_SIZE::Int = 10
const COND_NUMBER::Float64 = 1.0


function plotgen()
    functions::Vector{Function} = [solve_gauss!, solve_pivotgauss!, 
                                   solve_combinedlu!, solve_combinedpivotlu!]
    sizes::Vector{Int} = collect(2000:2000:100000)
    times::Vector{Vector{Float64}} = Vector{Vector{Float64}}(undef, length(functions))
    

    println("====================[ GENERATING PLOTS FOR EACH FUNCTION ]====================")

    # Pierwsze wywołanie wszystkich funkcji dla wymuszenia ich 
    # kompilacji, uniknąjąc tym zawyżonego wyniku czasu.
    for func in functions
        matrixgen.blockmat(100, BLOCK_SIZE, COND_NUMBER, "Atemp.txt")
            
        readmat::READ_MATRIX_TYPE = readmatrix("Atemp.txt")
        sparsematrix::MySparseMatrix = MySparseMatrix(readmat[1], readmat[2], readmat[3])
        resultvec::Vector{Float64} = solve_resultvector(sparsematrix)

        func(deepcopy(sparsematrix), deepcopy(resultvec))
    end


    for (funccount, func) in enumerate(functions)
        println("\n\t\t     >> Tested function: $func <<")
        times[funccount] = Vector{Float64}(undef, length(sizes))

        for (sizecount, size) in enumerate(sizes)
            println("\n--> Matrix size (n): $(size)\t Block size (l): $(BLOCK_SIZE) <<")
            
            matrixgen.blockmat(size, BLOCK_SIZE, COND_NUMBER, "Atemp.txt")
            
            readmat::READ_MATRIX_TYPE = readmatrix("Atemp.txt")
            sparsematrix::MySparseMatrix = MySparseMatrix(readmat[1], readmat[2], readmat[3])
            resultvec::Vector{Float64} = solve_resultvector(sparsematrix)
            
            time = @elapsed func(deepcopy(sparsematrix), deepcopy(resultvec))
            
            println(" \\--> Function runtime: $time seconds")
            
            times[funccount][sizecount] = time
        end

        rm("Atemp.txt")
    end
    
    complot = plot(sizes,
                   [time for time in times],
                   plot_title = "Czas działania poszczególnych funkcji (w sekundach)",
                   label = ["Gauss" "Pivot Gauss" "LU" "Pivot LU"],
                   legend_position = :topleft,
                   xlims = (0.0, 100000),
                   xticks = 0:20000:100000,
                   ylims = (0.0, 0.5),
                   yticks = 0.0:0.1:0.5,
                   linewidth = 2,
                   size = (800, 600),
                   dpi = 300)
                    
    Plots.png(complot, "complexityplot.png")
end


@time plotgen()