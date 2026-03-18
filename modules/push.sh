#!/usr/bin/env bash
# modules/push.sh — Push module for AutoGit
# Handles remote validation, SSH authentication check and git push execution.
#
# Depends on: autogit (core), i18n locale already loaded
# Compatible with: bash 4+, zsh 5+

# ---------------------------------------------------------------------------
# _push_resolve_remote — Validate and resolve the target remote
# Arguments: $1 — remote name (default: origin)
# Output: prints the remote URL to stdout
# ---------------------------------------------------------------------------
_push_resolve_remote() {
    local remote="$1"

    msg_fmt "${MSG_PUSH_REMOTE_RESOLVING}" "${remote}"

    # Abort if the remote does not exist in the repository
    if ! git remote get-url "${remote}" &>/dev/null; then
        msg_fmt "${MSG_PUSH_REMOTE_NOT_FOUND}" "${remote}"
        exit 1
    fi

    local url
    url="$(git remote get-url "${remote}")"
    msg_fmt "${MSG_PUSH_REMOTE_URL}" "${url}"

    printf "%s" "${url}"
}

# ---------------------------------------------------------------------------
# _push_resolve_branch — Resolve the current or specified branch
# Arguments: $1 — branch name (empty = use current branch)
# Output: prints the resolved branch name to stdout
# ---------------------------------------------------------------------------
_push_resolve_branch() {
    local branch="$1"

    if [[ -z "${branch}" ]]; then
        # Detect current branch name
        branch="$(git rev-parse --abbrev-ref HEAD)"
    fi

    msg_fmt "${MSG_PUSH_BRANCH_RESOLVING}" "${branch}"
    printf "%s" "${branch}"
}

# ---------------------------------------------------------------------------
# _push_extract_host — Extract SSH host from a remote URL
# Supports formats:
#   git@github.com:user/repo.git
#   ssh://git@github.com/user/repo.git
#   https://github.com/user/repo.git
# Arguments: $1 — remote URL
# Output: prints "ssh:<host>" or "https:<host>" to stdout
# ---------------------------------------------------------------------------
_push_extract_host() {
    local url="$1"

    if [[ "${url}" =~ ^git@ ]]; then
        # Format: git@host:path — extract host between @ and :
        local host
        host="$(echo "${url}" | cut -d'@' -f2 | cut -d':' -f1)"
        printf "ssh:%s" "${host}"

    elif [[ "${url}" =~ ^ssh:// ]]; then
        # Format: ssh://git@host/path — extract host after @
        local host
        host="$(echo "${url}" | sed 's|ssh://[^@]*@||' | cut -d'/' -f1)"
        printf "ssh:%s" "${host}"

    elif [[ "${url}" =~ ^https?:// ]]; then
        # Format: https://host/path
        local host
        host="$(echo "${url}" | sed 's|https\?://||' | cut -d'/' -f1)"
        printf "https:%s" "${host}"

    else
        msg_fmt "${MSG_PUSH_PROTOCOL_UNKNOWN}" "${url}" >&2
        exit 1
    fi
}

# ---------------------------------------------------------------------------
# _push_test_ssh — Test SSH authentication against a known host
# Arguments: $1 — hostname (e.g.: github.com)
# Returns: 0 if authenticated, 1 if failed
# ---------------------------------------------------------------------------
_push_test_ssh() {
    local host="$1"
    local exit_code=0

    msg_fmt "${MSG_PUSH_SSH_TESTING}" "${host}"

    # ssh -T: disable pseudo-terminal; BatchMode: no password prompts
    # GitHub exits with code 1 even on success; GitLab exits 0 on success
    # We check stderr output instead of exit code for reliability
    local ssh_output
    ssh_output="$(ssh -T -o BatchMode=yes -o ConnectTimeout=8 \
        "git@${host}" 2>&1)" || exit_code=$?

    # Normalize output to lowercase for pattern matching
    local output_lower
    output_lower="$(echo "${ssh_output}" | tr '[:upper:]' '[:lower:]')"

    # GitHub: "you've successfully authenticated"
    # GitLab: "welcome to gitlab"
    if echo "${output_lower}" | grep -qE \
        "successfully authenticated|welcome to gitlab"; then
        msg_fmt "${MSG_PUSH_SSH_OK}" "${host}"
        return 0
    fi

    # Known failure patterns
    if echo "${output_lower}" | grep -qE \
        "permission denied|publickey|no supported authentication"; then
        msg_fmt "${MSG_PUSH_SSH_FAIL}" "${host}" >&2
        msg_info "${MSG_PUSH_SSH_HINT}" >&2
        msg_info "${MSG_PUSH_SSH_HINT2}" >&2
        return 1
    fi

    # Host unreachable or unknown
    if echo "${output_lower}" | grep -qE \
        "could not resolve|connection refused|no route to host|connection timed out"; then
        msg_fmt "${MSG_PUSH_SSH_UNKNOWN_HOST}" "${host}" >&2
        return 1
    fi

    # Unrecognized output: warn but do not block push
    msg_fmt "${MSG_PUSH_HOST_UNSUPPORTED}" "${host}" >&2
    return 0
}

# ---------------------------------------------------------------------------
# _push_validate_ssh — Orchestrate protocol detection and SSH validation
# Arguments: $1 — remote URL
# ---------------------------------------------------------------------------
_push_validate_connection() {
    local url="$1"
    local proto_host
    proto_host="$(_push_extract_host "${url}")"

    local protocol="${proto_host%%:*}"
    local host="${proto_host#*:}"

    case "${protocol}" in
        ssh)
            msg_info "${MSG_PUSH_PROTOCOL_SSH}"
            # Test SSH; exit if authentication fails
            if ! _push_test_ssh "${host}"; then
                exit 1
            fi
            ;;
        https)
            msg_info "${MSG_PUSH_PROTOCOL_HTTPS}"
            msg_info "${MSG_PUSH_HTTPS_INFO}"
            ;;
    esac
}

# ---------------------------------------------------------------------------
# _push_execute — Run git push or simulate it in dry-run mode
# Arguments: $1 — remote, $2 — branch
# ---------------------------------------------------------------------------
_push_execute() {
    local remote="$1"
    local branch="$2"

    if [[ "${AUTOGIT_DRY_RUN:-false}" == "true" ]]; then
        msg_fmt "${MSG_PUSH_DRY}" "${remote}" "${branch}"
        msg_info "${MSG_DRY_RUN}"
        return 0
    fi

    msg_fmt "${MSG_PUSH_RUNNING}" "${remote}" "${branch}"
    git push "${remote}" "${branch}"
    msg_fmt "${MSG_PUSH_SUCCESS}" "${remote}" "${branch}"
}

# ---------------------------------------------------------------------------
# module_push — Public entry point for the push module
# Usage: module_push [--remote <name>] [--branch <name>]
# ---------------------------------------------------------------------------
module_push() {
    _autogit_require_repo

    local remote="origin"
    local branch=""

    # Parse push-specific arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --remote)
                [[ $# -lt 2 ]] && msg_die "$(printf "${MSG_COMMIT_MISSING_ARG}" "--remote")"
                remote="$2"
                shift 2
                ;;
            --branch)
                [[ $# -lt 2 ]] && msg_die "$(printf "${MSG_COMMIT_MISSING_ARG}" "--branch")"
                branch="$2"
                shift 2
                ;;
            -h|--help)
                cmd_help
                return 0
                ;;
            *)
                msg_fmt "${MSG_PUSH_INVALID_OPT}" "$1" >&2
                exit 1
                ;;
        esac
    done

    printf "\n%s\n\n" "${MSG_PUSH_TITLE}"

    # Resolve remote URL and branch name
    local remote_url
    remote_url="$(_push_resolve_remote "${remote}")"

    branch="$(_push_resolve_branch "${branch}")"

    # Validate connection (SSH or HTTPS)
    _push_validate_connection "${remote_url}"

    # Execute push
    _push_execute "${remote}" "${branch}"
}