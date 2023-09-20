# openresty_godlp
How to call a Golang project from OpenResty using Lua, with an example (data desensitization using godlp from bytedance)
####How to use

nginx.conf

      ... 
      lua_package_cpath "your path";
      lua_package_path  "your path";
      init_worker_by_lua_block {
         local dlpengine = require "dlp"
         dlpengine.init_worker("/yourdlp.yaml")
      }
      server {
	 body_filter_by_lua_block {
           local dlpengine = require "dlp"
           dlpengine.body_filter_by_lua()
         }
        ...
      }
