<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>webpan - Registe</title>

    <!-- Favicon -->
    <link rel="icon" href="/webpan/dist/media/img/favicon.png" type="image/png">
	<script src="https://cdn.staticfile.org/jquery/1.10.2/jquery.min.js"></script>
    <!-- Bundle Styles -->
    <link rel="stylesheet" href="/webpan/vendor/bundle.css">

    <!-- App styles -->
    <link rel="stylesheet" href="/webpan/dist/css/app.min.css">
</head>
<body class="form-membership">

<div class="form-wrapper">

    <!-- logo -->
    <div class="logo">
        <svg version="1.1" xmlns="http://www.w3.org/2000/svg"
             xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
             width="612px" height="612px" viewBox="0 0 612 612"
             style="enable-background:new 0 0 612 612;" xml:space="preserve">
            <g>
                <g id="_x32__26_">
                    <g>
                    <path d="M401.625,325.125h-191.25c-10.557,0-19.125,8.568-19.125,19.125s8.568,19.125,19.125,19.125h191.25
                    c10.557,0,19.125-8.568,19.125-19.125S412.182,325.125,401.625,325.125z M439.875,210.375h-267.75
                    c-10.557,0-19.125,8.568-19.125,19.125s8.568,19.125,19.125,19.125h267.75c10.557,0,19.125-8.568,19.125-19.125
                    S450.432,210.375,439.875,210.375z M306,0C137.012,0,0,119.875,0,267.75c0,84.514,44.848,159.751,114.75,208.826V612
                    l134.047-81.339c18.552,3.061,37.638,4.839,57.203,4.839c169.008,0,306-119.875,306-267.75C612,119.875,475.008,0,306,0z
                    M306,497.25c-22.338,0-43.911-2.601-64.643-7.019l-90.041,54.123l1.205-88.701C83.5,414.133,38.25,345.513,38.25,267.75
                    c0-126.741,119.875-229.5,267.75-229.5c147.875,0,267.75,102.759,267.75,229.5S453.875,497.25,306,497.25z"/>
                    </g>
                </g>
            </g>
            <g></g>
            <g></g>
            <g></g>
            <g></g>
            <g></g>
            <g></g>
            <g></g>
            <g></g>
            <g></g>
            <g></g>
            <g></g>
            <g></g>
            <g></g>
            <g></g>
            <g></g>
        </svg>
    </div>
    <!-- ./ logo -->

    <h5>Create account</h5>

    <!-- form -->
    <form>
        <div class="form-group">
            <input type="text" class="form-control" id="id" placeholder="Username" required autofocus>
        </div>

        <div class="form-group">
            <input type="email" class="form-control" id="email" placeholder="Email" required>
        </div>
        <div class="form-group">
            <input type="password" class="form-control" id="pass" placeholder="Password" required>
        </div>
        <button type="button" class="btn btn-primary btn-block" id="register">Register</button>
        <hr>
        <p class="text-muted">Already have an account?</p>
        <a href="/webpan/user/loginpage" class="btn btn-outline-light btn-sm">Sign in!</a>
    </form>
    <!-- ./ form -->

</div>

<!-- Bundle -->
<script src="https://www.jq22.com/jquery/jquery-3.3.1.js"></script>
<script src="/webpan/vendor/bundle.js"></script>
<script src="/webpan/vendor/feather.min.js"></script>
<script type="application/javascript">
	$("#register").click(function () {
		var id=document.getElementById("id").value;
		var email=document.getElementById("email").value;
		var pass=document.getElementById("pass").value;
		var registerForm={"UserName":id,"UserEmail":email,"UserPass":pass};
		$.post("/webpan/user/register",registerForm,function(result){
			if(result.toString()=="true"){//注册检查
	        	alert("Register successfully!!");
	            window.location.href="/webpan/user/loginpage";
	        }else if(result.toString()=="false"){
				alert("Register failed!!");
	        }else if(result.toString()=="namerepeat"){
	        	alert("Register failed!! username repeat");
	        }else if(result.toString()=="emailfalse"){
	        	alert("Register failed!! Email address format is not correct");
	        }else if(result.toString()=="passflase"){
	        	alert("Register failed!! password lengh should be 6-16");
	        }else if(result.toString()=="passbad"){
	        	alert("Register failed!! password includes illegal chars");
	        }else if(result.toString()=="emailrepeat"){
	        	alert("Register failed!! Email address repeat");
	        }else if(result.toString()=="usernamebad"){
	        	alert("Register failed!! username includes illegal chars");
	        }
		})
	});
	
</script>
<!-- App scripts -->
<script src="/webpan/dist/js/app.min.js"></script>
</body>
</html>