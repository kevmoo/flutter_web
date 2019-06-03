// Rapid workflow to label a Flutter Web static content MPM and update
// the version map in Piper.

// parameter "mpm_path" is the path to the MPM
// parameter "version_map" is the path to the version map file
// parameter "label" is the MPM label

import '//pipeline/patchpanel/gcl/patchpanel.gcl' as patchpanel
import '//releasetools/rapid/workflows/rapid.pp' as rapid

vars = rapid.create_vars() {}

add_dir = '$$RAPID_PROCESS_DIR/add_to_head/google3'

release_version = "%%(release_name)s"
local _cand_ver_list = findall(vars.candidate_name, '(\d{8}_RC\d{1,2})')
local _cand_ver = cond(len(_cand_ver_list) > 0, _cand_ver_list[0],
                       "bad_candidate version - parse failed.")
candidate_version = _cand_ver

mpm_path = vars.process_arguments.get('mpm_path')[0]
version_map = var.process_arguments.get('version_map')[0]
label = vars.process_arguments.get('label', ['qa'])[0]

task_deps = [
    'label_package': ['start'],
    'blaze_run-generate_version_map': ['label_package'],
    'submit_files-version_map': ['blaze_run-generate_version_map'],
]

task_properties = [
    'label_package': ["mpm_label=%label%"],
    'blaze_run-generate_version_map': ["args=//java/com/google/ads/acx/deploy/flutterweb:generate_version_map --mpm_path=%mpm_path% --version_map=%add_dir%/%version_map%"],
    'submit_files-version_map': [
      "submit_files_description=Update %version_map% to push %candidate_version% to %label% started by {on_behalf_of_or_launched_by}.",
      "submit_files_cc={on_behalf_of_or_launched_by}",
      "submit_files_wait_for_review=False",
      "wait_for_srcfs=True",
      "run_presubmit=True",
      "dry_run=True",
      "files_matching_regex=%version_map%",
    ],
]

workflow label_version_and_update_map = rapid.workflow([task_deps, task_properties]) {
  vars = @vars
}
