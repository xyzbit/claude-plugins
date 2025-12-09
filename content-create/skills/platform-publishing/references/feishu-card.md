## 飞书消息卡片json 结构
卡片 interactive 格式文档：https://open.feishu.cn/document/server-docs/im-v1/message-content-description/create_json#3ea4c2d5

## 示例
```json
{
    "schema": "2.0",
    "config": {
        "update_multi": true,
        "style": {
            "text_size": {
                "normal_v2": {
                    "default": "normal",
                    "pc": "normal",
                    "mobile": "heading"
                }
            }
        }
    },
    "body": {
        "direction": "vertical",
        "elements": [
            {
                "tag": "img",
                "img_key": "img_v3_02sf_94acd24b-7268-4bfd-80d0-5afcf306fe1g",
                "scale_type": "fit_horizontal",
                "corner_radius": "8px",
                "margin": "0px 0px 0px 0px"
            },
            {
                "tag": "markdown",
                "content": "${content}",
                "text_align": "left",
                "text_size": "normal_v2",
                "margin": "0px 0px 0px 0px",
                "element_id": "c4cjOOeHbDCUPWhMngAF"
            },
            {
                "tag": "button",
                "text": {
                    "tag": "plain_text",
                    "content": "查看全部热点"
                },
                "type": "primary_filled",
                "width": "fill",
                "behaviors": [
                    {
                        "type": "open_url",
                        "default_url": "https://news.feishu.cn",
                        "pc_url": "",
                        "ios_url": "",
                        "android_url": ""
                    }
                ],
                "margin": "4px 0px 4px 0px",
                "element_id": "LSyY_t5eMS4DnnJB3wo1"
            }
        ]
    },
    "header": {
        "title": {
            "tag": "plain_text",
            "content": "每日AI热点资讯"
        },
        "subtitle": {
            "tag": "plain_text",
            "content": ""
        },
        "text_tag_list": [
            {
                "tag": "text_tag",
                "text": {
                    "tag": "plain_text",
                    "content": "科技"
                },
                "color": "blue"
            }
        ],
        "template": "blue",
        "icon": {
            "tag": "standard_icon",
            "token": "news"
        },
        "padding": "12px 8px 12px 8px"
    }
}
```