local originalTextures = {
    ["badlands.txd"] = {701, 702},
    ["bistro_plants.txd"] = {3946},
    ["des_trees.txd"] = {16060, 16061},
    ["gta_deserttrees.txd"] = {674, 675, 676, 677, 678, 679, 680, 681, 682, 692},
    ["gta_potplants.txd"] = {630},
    ["gta_potplants2.txd"] = {626},
    ["gta_potplantsaa.txd"] = {625, 629, 632, 634},
    ["gta_proc_bigbush.txd"] = {825, 826},
    ["gta_proc_bush.txd"] = {647, 800, 803, 805},
    ["gta_proc_bushland.txd"] = {802, 810, 821},
    ["gta_proc_ferns.txd"] = {801, 808, 809, 820, 822, 856},
    ["gta_proc_grassland.txd"] = {812, 814, 815},
    ["gta_proc_grasslanda.txd"] = {804, 811, 813, 857},
    ["gta_proc_rushes.txd"] = {806, 855, 872},
    ["gta_procdesert.txd"] = {858, 859, 860, 861, 862, 863, 864, 865, 866, 904},
    ["gta_procflowers.txd"] = {817, 869, 870, 873, 874, 876, 877, 878},
    ["gta_procedesert.txd"] = {858, 859, 860, 861, 862, 863, 864, 865, 866, 904},
    ["gta_proc_flowers.txd"] = {817, 869, 870, 873, 874, 876, 877, 878},
    ["gta_tree_bevhills.txd"] = {716, 717, 718, 737, 738, 792},
    ["gta_tree_boak.txd"] = {615, 616, 617, 618, 669, 671, 672, 673, 691, 700, 703, 705, 706, 707, 708, 709, 713, 714, 715, 736, 789},
    ["gta_tree_oldpine.txd"] = {654, 655, 656, 657, 658, 659, 660, 661, 662, 663, 664},
    ["gta_tree_palm.txd"] = {710, 711, 712, 739, 740},
    ["gta_tree_pine.txd"] = {670, 683, 684, 685, 686, 687, 688, 689, 690, 693, 694, 695, 696, 697, 698, 704, 719, 720, 721, 722, 723, 724, 725, 790, 791},
    ["gta_tree_pineprc.txd"] = {881},
    ["gtarock_deserts.txd"] = {744, 745, 746, 747, 748, 749, 750, 751, 758},
    ["gtatreesh.txd"] = {726, 733},
    ["gtatreesh04.txd"] = {727},
    ["gtatreeshi.txd"] = {728},
    ["gtatreeshi7.txd"] = {729},
    ["gtatreeshi9.txd"] = {731},
    ["gtatreeshifir.txd"] = {730},
    ["tree1.txd"] = {767, 768},
    ["tree1prc.txd"] = {886, 887, 890, 893, 894},
    ["tree2.txd"] = {764, 765, 766, 769, 771, 773, 775, 781},
    ["tree2prc.txd"] = {883, 884, 885, 888, 891, 895},
    ["tree3.txd"] = {763, 770, 776, 777, 779},
    ["tree3prc.txd"] = {882, 889, 892},
    ["veg_fuzzyplant.txd"] = {818, 819, 823, 824, 827, 871, 875},
    ["veg_leaves.txd"] = {635, 636, 637, 639},
    ["vegtresshi9b.txd"] = {734, 735},
    ["vgsn_nitree.txd"] = {3505, 3506, 3507, 3508, 3509, 3510, 3511, 3512}
}

addEventHandler("onClientResourceStart", resourceRoot, function()
    for texture, modelIDs in pairs(originalTextures) do
        local txd = engineLoadTXD("public/textures/" .. texture)
        if txd then
            for _, modelID in ipairs(modelIDs) do
                engineImportTXD(txd, modelID)
            end
        end
    end
end)