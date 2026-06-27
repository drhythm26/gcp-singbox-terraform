#!/usr/bin/env bash
set -eu
# 注意！！！！！！！！！
# 使用前要更改下列变量 确定文件输出位置 以及 gcp项目名
OUTPUT_FILE="/mnt/d/Scoop/apps/sing-box/current/conf.d/04-outbounds.json"
PROJECT="lab-20260627"


build() {
    bash ./scripts/gen-keys.sh
    cat > ./terraform.tfvars << EOF
project_id = "${PROJECT}"
client_config_path = "${OUTPUT_FILE}"
EOF
    terraform apply -auto-approve
}

destroy() {
    read -r -p "确定要销毁全部GCP资源吗？(Y/n): " confirm
    if [[ ${confirm:-n} =~ ^[Yy]$ || -z ${confirm} ]];then
        terraform destroy -auto-approve
        rm -rf ./keys.auto.tfvars
    else
        echo "取消销毁"
        exit 0
    fi
}

main() {
    [[ -z ${1:-} ]] && echo "请传入参数" && exit 1
    local flag=$1
    if [[ "$flag" == "build" ]];then
        build
    elif [[ "$flag" == "destroy" ]];then
        destroy
    else
        echo "使用如下格式"
        echo "./start.sh build"
        echo "./start.sh destroy"
        exit 1
    fi
}

main "$@"