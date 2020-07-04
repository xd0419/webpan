function logout() {
		 if(confirm("确认退出登录？")){
			 window.location.href="/webpan/user/logout";
	   	  }
	   	  else{
	   		  return;
	   	  }
        }