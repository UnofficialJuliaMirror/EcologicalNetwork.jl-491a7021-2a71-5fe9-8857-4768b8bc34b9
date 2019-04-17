function nz_stream_foodweb()
  data_path = joinpath(@__DIR__, "../..", "data", "nz_stream")
  files = readdir(data_path)
  documents = filter(f -> endswith(f, ".csv"), files)
  Ns = UnipartiteNetwork{Bool,String}[]
  for doc in documents
    content = readdlm(joinpath(@__DIR__, "../..", "data", "nz_stream", doc), ',')
    species_names = convert(Array{String}, content[:,1][2:end])
    interaction_matrix = map(Int64, content[2:end,2:end]).>0
    push!(Ns, UnipartiteNetwork(interaction_matrix', species_names))
  end
  return Ns
end

function web_of_life(name)
  file_pathname = name * ".csv"
  data_path = joinpath(@__DIR__, "../..", "data", "weboflife")
  files = readdir(data_path)
  @assert file_pathname in files
  content = readdlm(joinpath(@__DIR__, "../..", "data", "weboflife", file_pathname), ',')
  bottom_species_names = convert(Array{String}, vec(content[:,1][2:end]))
  top_species_names = convert(Array{String}, vec(content[1,:][2:end]))
  int_mat = content[2:end,2:end]
  repl = findall(int_mat .== "#")
  int_mat[repl] .= 0.0
  interaction_matrix = map(Int64, round.(permutedims(int_mat)))
  ntype = BipartiteQuantitativeNetwork
  if maximum(interaction_matrix) == 1
    interaction_matrix = interaction_matrix .> 0
    ntype = BipartiteNetwork
  end
  this_net = ntype(interaction_matrix, top_species_names, bottom_species_names)
  forbidden_names = ["Numbers of flowers", "Num. of hosts sampled", "#", "Frequency of occurrences", "Number of flowers", "Number of droppings analysed"]
  sp_1 = filter(x -> !(x ∈ forbidden_names), species(this_net; dims=1))
  sp_2 = filter(x -> !(x ∈ forbidden_names), species(this_net; dims=2))
  return this_net[sp_1, sp_2]
end

function web_of_life()
  wol_ref = joinpath(@__DIR__, "../..", "data", "weboflife", "references.csv")
  wol_infos = readdlm(wol_ref, ',')
  names = [Symbol(replace(n, " " => "_")) for n in wol_infos[1,:]]
  infos = [NamedTuple{tuple(names...)}(tuple(wol_infos[i,:]...)) for i in 2:size(wol_infos,1)]
  return infos
end

"""
    chesapeake_bay()

Returns the summer carbon flows in the Chesapeake Bay mesohaline ecosystem.

#### References

Baird, D., Ulanowicz, R.E., 1989. The Seasonal Dynamics of The Chesapeake Bay
Ecosystem. Ecological Monographs 59, 329–364. https://doi.org/10.2307/1943071
"""
function chesapeake_bay()
  taxa = Dict(1 => "phytoplankton", 2 => "bacteria in suspended poc", 3 =>
  "bacteria in sediment poc", 4 => "benthic diatoms", 5 => "free bacteria", 6 =>
  "heterotrophic microflagel", 7 => "ciliates", 8 => "zooplankton", 9 =>
  "ctenophores", 10 => "sea nettle", 11 => "other suspension feeders", 12 => "mya arenaria", 13 => "oysters",
  14 => "other polychaetes", 15 => "nereis", 16 =>
  "macoma spp.", 17 => "meiofauna", 18 => "crustacean deposit feeder",
  19 => "blue crab", 20 => "fish larvae", 21 => "alewife & blue herring",
  22 => "bay anchovy", 23 => "menhaden", 24 => "shad", 25 => "croaker",
  26 => "hogchoker", 27 => "spot", 28 => "white perch", 29 => "catfish",
  30 => "bluefish", 31 => "weakfish", 32 => "summer flounder",
  33 => "striped bass", 34 => "dissolved organic carbon",
  35 => "suspended particulate org", 36 => "sediment particulate orga",
  37 => "Input", 38 => "Output", 39 => "Respiration")

  edges = [(37,   1) => 522650.0000000, (37,   4) =>  77803.0000000, (37,  34) => 103188.0000000, (37,  35) => 185150.4000000, (8,  38) =>  18720.2400000, (12,  38) =>    533.1050000, (13,  38) =>   3133.6600000, (19,  38) =>   1325.1570000, (20,  38) =>      0.9376155, (21,  38) =>      4.0630230, (22,  38) =>     96.1815900, (23,  38) =>      7.6839110, (24,  38) =>      0.9376006, (25,  38) =>      1.3343430, (26,  38) =>     12.2117700, (27,  38) =>     55.7901100, (28,  38) =>     19.4779300, (29,  38) =>     28.5216700, (30,  38) =>      2.3624590, (31,  38) =>      8.3364240, (32,  38) =>      4.2375820, (33,  38) =>      4.6160970, (1,  39) => 239556.2000000, (2,  39) =>  15419.4500000, (3,  39) => 277306.4000000, (4,  39) =>  27832.0000000, (5,  39) =>  84148.4300000, (6,  39) =>  45766.6300000, (7,  39) =>  37288.1000000, (8,  39) =>  40631.3000000, (9,  39) =>   6698.6920000, (10,  39) =>   1119.4060000, (11,  39) =>   3455.9330000, (12,  39) =>   1930.2800000, (13,  39) =>   3243.6310000, (14,  39) =>  19939.5200000, (15,  39) =>   1400.1850000, (16,  39) =>  24477.1700000, (17,  39) =>  21384.0300000, (18,  39) =>   7624.7390000, (19,  39) =>   4297.8520000, (20,  39) =>      0.6251083, (21,  39) =>      8.7511260, (22,  39) =>    761.7415000, (23,  39) =>    226.8830000, (24,  39) =>      1.6669600, (25,  39) =>      2.5852990, (26,  39) =>     26.8146500, (27,  39) =>    129.3927000, (28,  39) =>     41.0061700, (29,  39) =>     58.7946700, (30,  39) =>      4.9066550, (31,  39) =>     31.5742200, (32,  39) =>      8.4751750, (33,  39) =>     10.1554200, (1,   7) =>  33671.4500000, (1,   8) =>  39440.6700000, (1,  11) =>   4458.0310000, (1,  12) =>   2415.3420000, (1,  13) =>   4687.3550000, (1,  22) =>    294.0877000, (1,  23) =>     22.0831200, (1,  34) =>  78834.6300000, (1,  35) => 119270.1000000, (2,   7) =>   1443.3160000, (2,   8) =>   1131.0060000, (2,   9) =>    124.1849000, (2,  11) =>    158.4640000, (2,  12) =>     71.0214200, (2,  13) =>    109.9190000, (2,  22) =>     13.3421800, (2,  23) =>      5.1316060, (2,  35) =>   4179.1800000, (2,  36) =>   9915.2890000, (3,  14) => 134896.3000000, (3,  15) =>  21021.1000000, (3,  16) =>  48089.0900000, (3,  17) =>  30162.7400000, (3,  18) =>  11805.2400000, (3,  36) => 100313.7000000, (4,  17) =>  18086.0000000, (4,  36) =>  31885.0000000, (5,   6) =>  91011.1200000, (5,  35) =>   6862.6860000, (6,   7) =>  32454.6600000, (6,  35) =>  12789.8300000, (7,   8) =>   7850.8370000, (7,   9) =>   3571.5850000, (7,  11) =>    301.3558000, (7,  12) =>    162.1086000, (7,  13) =>    315.9040000, (7,  35) =>  40009.6500000, (8,   9) =>   7165.5120000, (8,  10) =>   1207.4480000, (8,  20) =>      5.1048280, (8,  21) =>     26.7743000, (8,  22) =>   1598.1240000, (8,  23) =>    258.5752000, (8,  24) =>      5.4173680, (8,  35) =>  22905.0500000, (9,  10) =>    572.5732000, (9,  35) =>   6386.4730000, (9,  36) =>    608.8777000, (10,  35) =>    465.0319000, (10,  36) =>    195.5839000, (11,  19) =>    556.1747000, (11,  36) =>   3570.6830000, (12,  19) =>    225.1819000, (12,  26) =>      9.4262170, (12,  36) =>   1407.6480000, (13,  36) =>   1594.0610000, (14,  25) =>      6.0043720, (14,  26) =>     49.2024900, (14,  27) =>    261.8573000, (14,  28) =>     63.3794800, (14,  29) =>    127.4261000, (14,  36) => 114449.2000000, (15,  19) =>    293.5468000, (15,  25) =>      1.7512740, (15,  26) =>     11.6751600, (15,  27) =>     80.8921600, (15,  28) =>     49.2024500, (15,  29) =>     18.8470400, (15,  36) =>  19165.0200000, (16,  19) =>   3784.4500000, (16,  27) =>     45.8670600, (16,  36) =>  19782.0500000, (17,  36) =>  26864.7600000, (18,  19) =>    806.4227000, (18,  25) =>      0.2501829, (18,  26) =>     11.6752000, (18,  27) =>      1.6678860, (18,  29) =>     35.9429400, (18,  32) =>      0.7505485, (18,  36) =>   3323.8460000, (19,  19) =>    249.7562000, (19,  33) =>      2.0457840, (19,  36) =>   1458.4740000, (20,  36) =>      3.5421030, (21,  33) =>      0.2083602, (21,  36) =>     13.7517700, (22,  27) =>     15.1097800, (22,  28) =>     15.2139900, (22,  30) =>      2.8135460, (22,  31) =>     95.2437400, (22,  32) =>     12.8172700, (22,  33) =>     17.9233300, (22,  36) =>   1204.6150000, (23,  30) =>      2.6997520, (23,  32) =>      8.3069310, (23,  33) =>     11.0066800, (23,  36) =>    137.9989000, (24,  36) =>      2.8128020, (25,  36) =>      4.0864270, (26,  36) =>     42.9546900, (27,  30) =>      8.5701670, (27,  36) =>    211.6495000, (28,  36) =>     67.3184600, (29,  36) =>     94.9054400, (30,  36) =>      6.8147860, (31,  32) =>      4.4808280, (31,  36) =>     50.8521800, (32,  36) =>     13.6429500, (33,  36) =>     16.4127900, (34,   5) => 182022.2000000, (35,   2) =>  32570.3000000, (35,   7) =>  21930.1200000, (35,   8) =>  44101.0200000, (35,   9) =>   3405.3340000, (35,  11) =>   2664.9460000, (35,  12) =>   1457.1710000, (35,  13) =>   2858.2020000, (35,  22) =>    316.1070000, (35,  23) =>    108.7901000, (35,  36) => 288606.4000000, (36,   3) => 623594.4000000, (36,  19) =>   1417.6960000]

  S = length(taxa)
  A = zeros(Float64, (S,S))
  for (taxas, value) in edges
    f, t = taxas
    A[f,t] = value
  end

  U = UnipartiteQuantitativeNetwork(A, [taxa[i] for i in 1:S])
  return U

end
