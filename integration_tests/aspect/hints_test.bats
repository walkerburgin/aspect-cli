load "common.bats"

setup() {
    cd "$TEST_REPO" || exit 1

    touch BUILD.bazel WORKSPACE
}

teardown() {
    rm -rf BUILD.bazel WORKSPACE
    rm -f "$HOME/.aspect/cli/config.yaml"
}

@test 'can output hints' {
    cat >"$HOME/.aspect/cli/config.yaml" <<'EOF'
hints:
  - pattern: path
    hint: single line hint
  - pattern: root
    hint: |
      multi
      line
      hint
  - pattern: "package_path: (.*)"
    hint: hint with replace $1
EOF
    run aspect info
    [ "$status" -eq 0 ]
    assert_output --partial "| - single line hint                                                                       |"
    assert_output --partial "| - multi                                                                                  |"
    assert_output --partial "|   line                                                                                   |"
    assert_output --partial "|   hint                                                                                   |"
    assert_output --partial "| - hint with replace %workspace%                                                          |"
}
