const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const linkage = b.option(std.builtin.LinkMode, "linkage", "Linkage type for the library") orelse .static;

    const spirv_tools_dep = b.dependency("spirv_tools", .{});
    const spirv_headers_dep = b.dependency("spirv_headers", .{});

    b.addNamedLazyPath("root", spirv_tools_dep.path("."));

    const flags = .{""};

    const spvtools = b.addLibrary(.{
        .name = "spvtools",
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
        }),
        .linkage = linkage,
    });
    spvtools.linkLibCpp();
    spvtools.addIncludePath(b.path("include"));
    spvtools.addIncludePath(spirv_tools_dep.path("include"));
    spvtools.addIncludePath(spirv_tools_dep.path("."));
    spvtools.addIncludePath(spirv_headers_dep.path("include"));
    spvtools.addCSourceFiles(.{
        .root = spirv_tools_dep.path("."),
        .files = &spvtools_sources,
        .flags = &flags,
    });
    spvtools.installHeadersDirectory(b.path("include"), ".", .{ .include_extensions = &.{ "inc", "h", "hpp" } });
    spvtools.installHeadersDirectory(spirv_tools_dep.path("include/spirv-tools"), "spirv-tools", .{ .include_extensions = &.{ "inc", "h", "hpp" } });
    b.installArtifact(spvtools);

    const spvtools_val = b.addLibrary(.{
        .name = "spvtools_val",
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
        }),
        .linkage = linkage,
    });
    spvtools_val.linkLibCpp();
    spvtools_val.addIncludePath(b.path("include"));
    spvtools_val.addIncludePath(spirv_tools_dep.path("include"));
    spvtools_val.addIncludePath(spirv_tools_dep.path("."));
    spvtools_val.addIncludePath(spirv_headers_dep.path("include"));
    spvtools_val.addCSourceFiles(.{
        .root = spirv_tools_dep.path("."),
        .files = &spvtools_val_sources,
        .flags = &flags,
    });
    b.installArtifact(spvtools_val);

    const spvtools_opt = b.addLibrary(.{
        .name = "spvtools_opt",
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
        }),
        .linkage = linkage,
    });
    spvtools_opt.linkLibCpp();
    spvtools_opt.addIncludePath(b.path("include"));
    spvtools_opt.addIncludePath(spirv_tools_dep.path("include"));
    spvtools_opt.addIncludePath(spirv_tools_dep.path("."));
    spvtools_opt.addIncludePath(spirv_headers_dep.path("include"));
    spvtools_opt.addCSourceFiles(.{
        .root = spirv_tools_dep.path("."),
        .files = &spvtools_opt_sources,
        .flags = &flags,
    });
    b.installArtifact(spvtools_opt);

    const spvtools_link = b.addLibrary(.{
        .name = "spvtools_link",
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
        }),
        .linkage = linkage,
    });
    spvtools_link.linkLibCpp();
    spvtools_link.addIncludePath(b.path("include"));
    spvtools_link.addIncludePath(spirv_tools_dep.path("include"));
    spvtools_link.addIncludePath(spirv_tools_dep.path("."));
    spvtools_link.addIncludePath(spirv_headers_dep.path("include"));
    spvtools_link.addCSourceFiles(.{
        .root = spirv_tools_dep.path("."),
        .files = &spvtools_link_sources,
        .flags = &flags,
    });
    b.installArtifact(spvtools_link);

    const spvtools_reduce = b.addLibrary(.{
        .name = "spvtools_reduce",
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
        }),
        .linkage = linkage,
    });
    spvtools_reduce.linkLibCpp();
    spvtools_reduce.addIncludePath(b.path("include"));
    spvtools_reduce.addIncludePath(spirv_tools_dep.path("include"));
    spvtools_reduce.addIncludePath(spirv_tools_dep.path("."));
    spvtools_reduce.addIncludePath(spirv_headers_dep.path("include"));
    spvtools_reduce.addCSourceFiles(.{
        .root = spirv_tools_dep.path("."),
        .files = &spvtools_reduce_sources,
        .flags = &flags,
    });
    b.installArtifact(spvtools_reduce);

    const grammar_unified_dir = spirv_headers_dep.path("include/spirv/unified1");
    // const grammar_1_dir = spirv_headers_dep.path("include/spirv/1.0");

    const gen_core_tables_cmd = b.addSystemCommand(&.{"python3"});
    gen_core_tables_cmd.addFileArg(spirv_tools_dep.path("utils/ggt.py"));
    gen_core_tables_cmd.addPrefixedFileArg("--spirv-core-grammar=", grammar_unified_dir.path(b, "spirv.core.grammar.json"));
    gen_core_tables_cmd.addPrefixedFileArg("--extinst=,", grammar_unified_dir.path(b, "extinst.debuginfo.grammar.json"));
    gen_core_tables_cmd.addPrefixedFileArg("--extinst=,", grammar_unified_dir.path(b, "extinst.glsl.std.450.grammar.json"));
    gen_core_tables_cmd.addPrefixedFileArg("--extinst=,", grammar_unified_dir.path(b, "extinst.nonsemantic.clspvreflection.grammar.json"));
    gen_core_tables_cmd.addPrefixedFileArg("--extinst=SHDEBUG100_,", grammar_unified_dir.path(b, "extinst.nonsemantic.shader.debuginfo.100.grammar.json"));
    gen_core_tables_cmd.addPrefixedFileArg("--extinst=,", grammar_unified_dir.path(b, "extinst.nonsemantic.vkspreflection.grammar.json"));
    gen_core_tables_cmd.addPrefixedFileArg("--extinst=CLDEBUG100_,", grammar_unified_dir.path(b, "extinst.opencl.debuginfo.100.grammar.json"));
    gen_core_tables_cmd.addPrefixedFileArg("--extinst=,", grammar_unified_dir.path(b, "extinst.opencl.std.100.grammar.json"));
    gen_core_tables_cmd.addPrefixedFileArg("--extinst=,", grammar_unified_dir.path(b, "extinst.spv-amd-gcn-shader.grammar.json"));
    gen_core_tables_cmd.addPrefixedFileArg("--extinst=,", grammar_unified_dir.path(b, "extinst.spv-amd-shader-ballot.grammar.json"));
    gen_core_tables_cmd.addPrefixedFileArg("--extinst=,", grammar_unified_dir.path(b, "extinst.spv-amd-shader-explicit-vertex-parameter.grammar.json"));
    gen_core_tables_cmd.addPrefixedFileArg("--extinst=,", grammar_unified_dir.path(b, "extinst.spv-amd-shader-trinary-minmax.grammar.json"));
    gen_core_tables_cmd.addPrefixedFileArg("--core-tables-body-output=", b.path("include/core_tables_body.inc"));
    gen_core_tables_cmd.addPrefixedFileArg("--core-tables-header-output=", b.path("include/core_tables_header.inc"));

    const gen_generators_inc_cmd = b.addSystemCommand(&.{"python3"});
    gen_generators_inc_cmd.addFileArg(spirv_tools_dep.path("utils/generate_registry_tables.py"));
    gen_generators_inc_cmd.addPrefixedFileArg("--xml=", spirv_headers_dep.path("include/spirv/spir-v.xml"));
    gen_generators_inc_cmd.addPrefixedFileArg("--generator=", b.path("include/generators.inc"));

    const gen_build_version_cmd = b.addSystemCommand(&.{"python3"});
    gen_build_version_cmd.addFileArg(spirv_tools_dep.path("utils/update_build_version.py"));
    gen_build_version_cmd.addFileArg(spirv_tools_dep.path("CHANGES"));
    gen_build_version_cmd.addFileArg(b.path("include/generators.inc"));

    const gen_language_header_debuginfo_step = spvtools_language_header(b, "DebugInfo", spirv_headers_dep.path("include/spirv/unified1/extinst.debuginfo.grammar.json"));
    const gen_language_header_cldebuginfo100_step = spvtools_language_header(b, "OpenCLDebugInfo100", spirv_headers_dep.path("include/spirv/unified1/extinst.opencl.debuginfo.100.grammar.json"));
    const gen_language_header_vkdebuginfo100_step = spvtools_language_header(b, "NonSemanticShaderDebugInfo100", spirv_headers_dep.path("include/spirv/unified1/extinst.nonsemantic.shader.debuginfo.100.grammar.json"));

    const gen_step = b.step("gen", "include/build-version.inc");
    gen_step.dependOn(&gen_core_tables_cmd.step);
    gen_step.dependOn(&gen_generators_inc_cmd.step);
    gen_step.dependOn(gen_language_header_debuginfo_step);
    gen_step.dependOn(gen_language_header_cldebuginfo100_step);
    gen_step.dependOn(gen_language_header_vkdebuginfo100_step);
}

fn spvtools_language_header(b: *std.Build, name: []const u8, grammar_file: std.Build.LazyPath) *std.Build.Step {
    const spirv_tools_dep = b.dependency("spirv_tools", .{});

    const cmd = b.addSystemCommand(&.{"python3"});
    cmd.addFileArg(spirv_tools_dep.path("utils/generate_language_headers.py"));
    cmd.addPrefixedFileArg("--extinst-grammar=", grammar_file);
    cmd.addPrefixedFileArg("--extinst-output-path=", b.path(b.fmt("include/{s}.h", .{name})));

    return &cmd.step;
}

const spvtools_sources = .{
    "source/assembly_grammar.cpp",
    "source/binary.cpp",
    "source/diagnostic.cpp",
    "source/disassemble.cpp",
    "source/ext_inst.cpp",
    "source/extensions.cpp",
    "source/libspirv.cpp",
    "source/name_mapper.cpp",
    "source/opcode.cpp",
    "source/operand.cpp",
    "source/parsed_operand.cpp",
    "source/print.cpp",
    "source/spirv_endian.cpp",
    "source/spirv_fuzzer_options.cpp",
    "source/spirv_optimizer_options.cpp",
    "source/spirv_reducer_options.cpp",
    "source/spirv_target_env.cpp",
    "source/spirv_validator_options.cpp",
    "source/table.cpp",
    "source/table2.cpp",
    "source/text.cpp",
    "source/text_handler.cpp",
    "source/to_string.cpp",
    "source/util/bit_vector.cpp",
    "source/util/parse_number.cpp",
    "source/util/string_utils.cpp",
    "source/util/timer.cpp",
};

const spvtools_val_sources = .{
    "source/val/basic_block.cpp",
    "source/val/construct.cpp",
    "source/val/function.cpp",
    "source/val/instruction.cpp",
    "source/val/validate.cpp",
    "source/val/validate_adjacency.cpp",
    "source/val/validate_annotation.cpp",
    "source/val/validate_arithmetics.cpp",
    "source/val/validate_atomics.cpp",
    "source/val/validate_barriers.cpp",
    "source/val/validate_bitwise.cpp",
    "source/val/validate_builtins.cpp",
    "source/val/validate_capability.cpp",
    "source/val/validate_cfg.cpp",
    "source/val/validate_composites.cpp",
    "source/val/validate_constants.cpp",
    "source/val/validate_conversion.cpp",
    "source/val/validate_debug.cpp",
    "source/val/validate_decorations.cpp",
    "source/val/validate_derivatives.cpp",
    "source/val/validate_execution_limitations.cpp",
    "source/val/validate_extensions.cpp",
    "source/val/validate_function.cpp",
    "source/val/validate_id.cpp",
    "source/val/validate_image.cpp",
    "source/val/validate_instruction.cpp",
    "source/val/validate_interfaces.cpp",
    "source/val/validate_layout.cpp",
    "source/val/validate_literals.cpp",
    "source/val/validate_logicals.cpp",
    "source/val/validate_memory.cpp",
    "source/val/validate_memory_semantics.cpp",
    "source/val/validate_mesh_shading.cpp",
    "source/val/validate_misc.cpp",
    "source/val/validate_mode_setting.cpp",
    "source/val/validate_non_uniform.cpp",
    "source/val/validate_primitives.cpp",
    "source/val/validate_ray_query.cpp",
    "source/val/validate_ray_tracing.cpp",
    "source/val/validate_ray_tracing_reorder.cpp",
    "source/val/validate_scopes.cpp",
    "source/val/validate_small_type_uses.cpp",
    "source/val/validate_tensor.cpp",
    "source/val/validate_tensor_layout.cpp",
    "source/val/validate_type.cpp",
    "source/val/validate_invalid_type.cpp",
    "source/val/validation_state.cpp",
};

const spvtools_opt_sources = .{
    "source/opt/aggressive_dead_code_elim_pass.cpp",
    "source/opt/amd_ext_to_khr.cpp",
    "source/opt/analyze_live_input_pass.cpp",
    "source/opt/basic_block.cpp",
    "source/opt/block_merge_pass.cpp",
    "source/opt/block_merge_util.cpp",
    "source/opt/build_module.cpp",
    "source/opt/ccp_pass.cpp",
    "source/opt/cfg.cpp",
    "source/opt/cfg_cleanup_pass.cpp",
    "source/opt/code_sink.cpp",
    "source/opt/combine_access_chains.cpp",
    "source/opt/compact_ids_pass.cpp",
    "source/opt/composite.cpp",
    "source/opt/const_folding_rules.cpp",
    "source/opt/constants.cpp",
    "source/opt/control_dependence.cpp",
    "source/opt/convert_to_half_pass.cpp",
    "source/opt/convert_to_sampled_image_pass.cpp",
    "source/opt/copy_prop_arrays.cpp",
    "source/opt/dataflow.cpp",
    "source/opt/dead_branch_elim_pass.cpp",
    "source/opt/dead_insert_elim_pass.cpp",
    "source/opt/dead_variable_elimination.cpp",
    "source/opt/debug_info_manager.cpp",
    "source/opt/decoration_manager.cpp",
    "source/opt/def_use_manager.cpp",
    "source/opt/desc_sroa.cpp",
    "source/opt/desc_sroa_util.cpp",
    "source/opt/dominator_analysis.cpp",
    "source/opt/dominator_tree.cpp",
    "source/opt/eliminate_dead_constant_pass.cpp",
    "source/opt/eliminate_dead_functions_pass.cpp",
    "source/opt/eliminate_dead_functions_util.cpp",
    "source/opt/eliminate_dead_io_components_pass.cpp",
    "source/opt/eliminate_dead_members_pass.cpp",
    "source/opt/eliminate_dead_output_stores_pass.cpp",
    "source/opt/feature_manager.cpp",
    "source/opt/fix_func_call_arguments.cpp",
    "source/opt/fix_storage_class.cpp",
    "source/opt/flatten_decoration_pass.cpp",
    "source/opt/fold.cpp",
    "source/opt/fold_spec_constant_op_and_composite_pass.cpp",
    "source/opt/folding_rules.cpp",
    "source/opt/freeze_spec_constant_value_pass.cpp",
    "source/opt/function.cpp",
    "source/opt/graphics_robust_access_pass.cpp",
    "source/opt/if_conversion.cpp",
    "source/opt/inline_exhaustive_pass.cpp",
    "source/opt/inline_opaque_pass.cpp",
    "source/opt/inline_pass.cpp",
    "source/opt/instruction.cpp",
    "source/opt/instruction_list.cpp",
    "source/opt/interface_var_sroa.cpp",
    "source/opt/interp_fixup_pass.cpp",
    "source/opt/invocation_interlock_placement_pass.cpp",
    "source/opt/ir_context.cpp",
    "source/opt/ir_loader.cpp",
    "source/opt/licm_pass.cpp",
    "source/opt/liveness.cpp",
    "source/opt/local_access_chain_convert_pass.cpp",
    "source/opt/local_redundancy_elimination.cpp",
    "source/opt/local_single_block_elim_pass.cpp",
    "source/opt/local_single_store_elim_pass.cpp",
    "source/opt/loop_dependence.cpp",
    "source/opt/loop_dependence_helpers.cpp",
    "source/opt/loop_descriptor.cpp",
    "source/opt/loop_fission.cpp",
    "source/opt/loop_fusion.cpp",
    "source/opt/loop_fusion_pass.cpp",
    "source/opt/loop_peeling.cpp",
    "source/opt/loop_unroller.cpp",
    "source/opt/loop_unswitch_pass.cpp",
    "source/opt/loop_utils.cpp",
    "source/opt/mem_pass.cpp",
    "source/opt/merge_return_pass.cpp",
    "source/opt/modify_maximal_reconvergence.cpp",
    "source/opt/module.cpp",
    "source/opt/opextinst_forward_ref_fixup_pass.cpp",
    "source/opt/optimizer.cpp",
    "source/opt/pass.cpp",
    "source/opt/pass_manager.cpp",
    "source/opt/private_to_local_pass.cpp",
    "source/opt/propagator.cpp",
    "source/opt/reduce_load_size.cpp",
    "source/opt/redundancy_elimination.cpp",
    "source/opt/register_pressure.cpp",
    "source/opt/relax_float_ops_pass.cpp",
    "source/opt/remove_dontinline_pass.cpp",
    "source/opt/remove_duplicates_pass.cpp",
    "source/opt/remove_unused_interface_variables_pass.cpp",
    "source/opt/canonicalize_ids_pass.cpp",
    "source/opt/replace_desc_array_access_using_var_index.cpp",
    "source/opt/replace_invalid_opc.cpp",
    "source/opt/resolve_binding_conflicts_pass.cpp",
    "source/opt/scalar_analysis.cpp",
    "source/opt/scalar_analysis_simplification.cpp",
    "source/opt/scalar_replacement_pass.cpp",
    "source/opt/set_spec_constant_default_value_pass.cpp",
    "source/opt/simplification_pass.cpp",
    "source/opt/split_combined_image_sampler_pass.cpp",
    "source/opt/spread_volatile_semantics.cpp",
    "source/opt/ssa_rewrite_pass.cpp",
    "source/opt/strength_reduction_pass.cpp",
    "source/opt/strip_debug_info_pass.cpp",
    "source/opt/strip_nonsemantic_info_pass.cpp",
    "source/opt/struct_packing_pass.cpp",
    "source/opt/struct_cfg_analysis.cpp",
    "source/opt/switch_descriptorset_pass.cpp",
    "source/opt/trim_capabilities_pass.cpp",
    "source/opt/type_manager.cpp",
    "source/opt/types.cpp",
    "source/opt/unify_const_pass.cpp",
    "source/opt/upgrade_memory_model.cpp",
    "source/opt/value_number_table.cpp",
    "source/opt/vector_dce.cpp",
    "source/opt/workaround1209.cpp",
    "source/opt/wrap_opkill.cpp",
};

const spvtools_link_sources = .{
    "source/link/linker.cpp",
};

const spvtools_reduce_sources = .{
    "source/reduce/change_operand_reduction_opportunity.cpp",
    "source/reduce/change_operand_to_undef_reduction_opportunity.cpp",
    "source/reduce/conditional_branch_to_simple_conditional_branch_opportunity_finder.cpp",
    "source/reduce/conditional_branch_to_simple_conditional_branch_reduction_opportunity.cpp",
    "source/reduce/merge_blocks_reduction_opportunity.cpp",
    "source/reduce/merge_blocks_reduction_opportunity_finder.cpp",
    "source/reduce/operand_to_const_reduction_opportunity_finder.cpp",
    "source/reduce/operand_to_dominating_id_reduction_opportunity_finder.cpp",
    "source/reduce/operand_to_undef_reduction_opportunity_finder.cpp",
    "source/reduce/reducer.cpp",
    "source/reduce/reduction_opportunity.cpp",
    "source/reduce/reduction_opportunity_finder.cpp",
    "source/reduce/reduction_pass.cpp",
    "source/reduce/reduction_util.cpp",
    "source/reduce/remove_block_reduction_opportunity.cpp",
    "source/reduce/remove_block_reduction_opportunity_finder.cpp",
    "source/reduce/remove_function_reduction_opportunity.cpp",
    "source/reduce/remove_function_reduction_opportunity_finder.cpp",
    "source/reduce/remove_instruction_reduction_opportunity.cpp",
    "source/reduce/remove_selection_reduction_opportunity.cpp",
    "source/reduce/remove_selection_reduction_opportunity_finder.cpp",
    "source/reduce/remove_struct_member_reduction_opportunity.cpp",
    "source/reduce/remove_unused_instruction_reduction_opportunity_finder.cpp",
    "source/reduce/remove_unused_struct_member_reduction_opportunity_finder.cpp",
    "source/reduce/simple_conditional_branch_to_branch_opportunity_finder.cpp",
    "source/reduce/simple_conditional_branch_to_branch_reduction_opportunity.cpp",
    "source/reduce/structured_construct_to_block_reduction_opportunity.cpp",
    "source/reduce/structured_construct_to_block_reduction_opportunity_finder.cpp",
    "source/reduce/structured_loop_to_selection_reduction_opportunity.cpp",
    "source/reduce/structured_loop_to_selection_reduction_opportunity_finder.cpp",
};
