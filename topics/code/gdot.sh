# Variables
platforms="macos,deb,rpm"
context="code"

# Tasks
bootstrap() {
    create_dir "${gdot_code_dir}" 755
    create_dir "${gdot_code_dir}/personal" 755
    create_dir "${gdot_code_dir}/work" 755
    # create_dir "${code_dir}/provision/resources/ansible_collections/gummigudm" 755
}
