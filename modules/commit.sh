#!/usr/bin/env bash
# modules/commit.sh — Commit module for AutoGit
# Handles interactive and autonomous commit + tag creation workflows.
#
# Depends on: autogit (core), i18n locale already loaded
# Compatible with: bash 4+, zsh 5+

# ---------------------------------------------------------------------------
# _commit_read_message — Resolve a message from raw input or file path
# Arguments:
#   $1 — raw input (inline message or file path)
#   $2 — default file path if input is empty
# Output: prints the resolved message to stdout
# ---------------------------------------------------------------------------
_commit_read_message() {
    local input="$1"
    local default_file="$2"
    local resolved=""

    # Use default file path when input is empty
    if [[ -z "${input}" ]]; then
        input="${default_file}"
    fi

    # Treat input as a file path if it points to an existing file
    if [[ -f "${input}" ]]; then
        msg_fmt "${MSG_COMMIT_READING_FILE}" "${input}" >&2
        resolved="$(cat "${input}")"
    else
        # Treat input as an inline message string
        resolved="${input}"
    fi

    # Abort if the resolved message is still empty
    if [[ -z "${resolved}" ]]; then
        msg_fmt "${MSG_COMMIT_FILE_NOT_FOUND}" "${input}"
        return 1
    fi

    printf "%s" "${resolved}"
}

# ---------------------------------------------------------------------------
# _commit_has_changes — Check if there are staged or unstaged changes
# Returns 0 if there are changes, 1 if working tree is clean
# ---------------------------------------------------------------------------
_commit_has_changes() {
    # Check both staged and unstaged tracked changes
    if git diff --quiet && git diff --cached --quiet; then
        return 1
    fi
    return 0
}

# ---------------------------------------------------------------------------
# _commit_interactive — Run the interactive commit wizard
# Prompts the user for tag, tag message and commit message.
# Sets global variables: _TAG, _MSG_TAG, _MSG_COMMIT
# ---------------------------------------------------------------------------
_commit_interactive() {
    printf "\n%s\n\n" "${MSG_COMMIT_TITLE}"

    # Prompt: tag title / version
    printf "%s " "${MSG_COMMIT_ENTER_TAG}"
    read -r _TAG

    if [[ -z "${_TAG}" ]]; then
        msg_die "${MSG_COMMIT_TAG_EMPTY}"
    fi

    # Prompt: tag message or .msgtag file path
    printf "%s " "${MSG_COMMIT_ENTER_MSGTAG}"
    read -r _input_msgtag

    _MSG_TAG="$(_commit_read_message "${_input_msgtag}" "./.msgtag")" || exit 1

    # Prompt: commit message or .msgcommit file path
    printf "%s " "${MSG_COMMIT_ENTER_MSGCOMMIT}"
    read -r _input_msgcommit

    _MSG_COMMIT="$(_commit_read_message "${_input_msgcommit}" "./.msgcommit")" || exit 1
}

# ---------------------------------------------------------------------------
# _commit_autonomous — Parse CLI arguments for autonomous mode
# Expected flags: --tag <value> --msgtag <file> --msgcommit <file>
# Sets global variables: _TAG, _MSG_TAG, _MSG_COMMIT
# ---------------------------------------------------------------------------
_commit_autonomous() {
    local args=("$@")
    local i=0

    _TAG=""
    _MSG_TAG=""
    _MSG_COMMIT=""

    while [[ ${i} -lt ${#args[@]} ]]; do
        local arg="${args[${i}]}"

        case "${arg}" in
            --tag)
                i=$(( i + 1 ))
                _TAG="${args[${i}]:-}"
                ;;
            --msgtag)
                i=$(( i + 1 ))
                local msgtag_input="${args[${i}]:-}"
                _MSG_TAG="$(_commit_read_message "${msgtag_input}" "./.msgtag")" || exit 1
                ;;
            --msgcommit)
                i=$(( i + 1 ))
                local msgcommit_input="${args[${i}]:-}"
                _MSG_COMMIT="$(_commit_read_message "${msgcommit_input}" "./.msgcommit")" || exit 1
                ;;
            *)
                # Unknown option: report and abort
                msg_fmt "${MSG_COMMIT_INVALID_OPT}" "${arg}"
                exit 1
                ;;
        esac

        i=$(( i + 1 ))
    done

    # Validate required fields
    if [[ -z "${_TAG}" ]]; then
        msg_die "${MSG_COMMIT_TAG_EMPTY}"
    fi
}

# ---------------------------------------------------------------------------
# _commit_execute — Perform the actual git operations
# Reads globals: _TAG, _MSG_TAG, _MSG_COMMIT, AUTOGIT_DRY_RUN
# ---------------------------------------------------------------------------
_commit_execute() {
    # Verify we are inside a Git repository
    _autogit_require_repo

    # Abort if there is nothing to commit
    if ! _commit_has_changes; then
        msg_info "${MSG_COMMIT_NOTHING}"
        return 0
    fi

    if [[ "${AUTOGIT_DRY_RUN:-false}" == "true" ]]; then
        # Dry-run: display what would be done without applying changes
        msg_fmt "${MSG_COMMIT_DRY_TAG}"    "${_TAG}"
        msg_fmt "${MSG_COMMIT_DRY_MSG}"    "${_MSG_COMMIT}"
        msg_fmt "${MSG_COMMIT_DRY_MSGTAG}" "${_MSG_TAG}"
        msg_info "${MSG_DRY_RUN}"
        return 0
    fi

    # Stage all changes (tracked and untracked)
    msg_info "${MSG_COMMIT_STAGING}"
    git add --all

    # Create the commit with the resolved message
    msg_info "${MSG_COMMIT_CREATING}"
    git commit -m "${_MSG_COMMIT}"

    # Create the annotated tag with its message
    msg_fmt "${MSG_COMMIT_TAGGING}" "${_TAG}" >&2
    git tag -a "${_TAG}" -m "${_MSG_TAG}"

    msg_info "${MSG_COMMIT_SUCCESS}"
}

# ---------------------------------------------------------------------------
# module_commit — Public entry point for the commit module
# Called by the main dispatcher with remaining arguments after "commit"
# ---------------------------------------------------------------------------
module_commit() {
    # Declare shared variables used across functions in this module
    local _TAG=""
    local _MSG_TAG=""
    local _MSG_COMMIT=""

    if [[ $# -eq 0 ]]; then
        # No arguments: launch interactive wizard
        _commit_interactive
    else
        # Arguments present: parse as autonomous CLI flags
        _commit_autonomous "$@"
    fi

    _commit_execute
}