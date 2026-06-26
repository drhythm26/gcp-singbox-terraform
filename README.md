# Sing-box GCP 一键部署

> 用 Terraform 在 GCP 多区域（香港 / 新加坡）自动化部署 sing-box 代理服务。
> 基础设施、服务端配置注入、客户端配置生成全流程自动化，
> 通过 `start.sh build / destroy` 一键部署与销毁。

## 架构

```text
                      ┌─→ HK 节点 (asia-east2,  子网 10.0.1.0/24) :443
客户端 sing-box ──────┤
                      └─→ SG 节点 (asia-southeast1, 子网 10.0.2.0/24) :443

部署流程：
  ./start.sh build
    → gen-keys.sh 生成 reality 密钥/uuid/short_id
    → terraform apply
        → 建 VPC/子网/防火墙/双 GCE
        → startup script 在 GCE 上用 docker 跑 sing-box
        → local_file 把客户端配置写到本地
```

## 技术栈
- Terraform   — IaC，管理 GCP 全部资源
- GCP         — VPC / Subnetwork / Firewall / GCE
- Docker      — 在节点上容器化运行 sing-box
- templatefile— 渲染 config.json 和 startup script
- local_file  — 自动输出客户端配置到本地
- Shell       — start.sh 一键编排 + gen-keys.sh 密钥生成


## 目录结构

```text
├── main.tf          # provider + terraform 版本
├── network.tf       # VPC / 子网 / 防火墙
├── compute.tf       # 双区域 GCE + startup script
├── localfile.tf     # 输出客户端配置到本地
├── output.tf        # 输出节点通用链接以及json客户端配置
├── variables.tf     # 定义project_id、region 和 zone等变量
├── start.sh         # 一键部署脚本
├── scripts/gen-keys.sh        # 生成uuid、reality密钥、short_id
└── templates/                 # 服务端客户端配置文件模板，部署sing-box容器脚本模板
```

## 快速开始

### 前置条件
- 安装 Terraform、gcloud 并完成认证
- 修改 start.sh 顶部的 OUTPUT_FILE（客户端配置输出路径）和 PROJECT

### 部署
```bash
./start.sh build      # 一键部署
./start.sh destroy    # 一键销毁
```
## 核心设计 / 亮点
- 配置即代码：templatefile 嵌套渲染（config.json → startup script），
  服务端配置随基础设施一起版本化
- 客户端配置自动生成：local_file 把节点 IP/密钥渲染进客户端配置，
  apply 完直接可用，代替服务端生成配置，避免手动获取配置
- 密钥自动化：gen-keys.sh 自动生成 reality 密钥对/uuid/short_id
- 一键编排：start.sh 把 gen-keys + apply 封装成 build/destroy
