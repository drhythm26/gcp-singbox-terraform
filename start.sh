#!/usr/bin/env bash
set -eu

# 使用前要更改下列变量 确定文件输出位置 以及 gcp项目名
OUTPUT_FILE="/mnt/d/Scoop/apps/sing-box/current/conf.d/04-outbounds.json"
PROJECT="dev-2026522"


build() {
    bash ./scripts/gen-keys.sh
    sed -i "s/OUTPUT_FILE/${OUTPUT_FILE}/g" ./localfile.tf
    echo "project_id = ${PROJECT}" > ./terraform.tfvars
    terraform apply -auto-approve
}

destroy() {
    terraform destroy -auto-approve
}

main() {
    [[ -z $1 ]] && echo "请传入参数" && exit 1
    local flag=$1
    if [[ "$flag" == "build" ]];then
        build
    elif [[ "$flag" == "destroy" ]]
        destory
    else
        echo "使用如下格式"
        echo "./start build"
        echo "./start destroy"
        exit 1
    fi
}

main "$@"