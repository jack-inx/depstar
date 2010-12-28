var transparentImage = "images/transparent.gif";
function fixTrans()
{
	if (typeof document.body.style.maxHeight == 'undefined') {
	var imgs = document.getElementsByTagName("img");
	for (i = 0; i < imgs.length; i++)
	{
		if (imgs[i].src.indexOf(transparentImage) != -1)
		{
			return;
		}
		if (imgs[i].src.indexOf(".png") != -1)
			{
				var src = imgs[i].src;
				imgs[i].src = transparentImage;
				imgs[i].runtimeStyle.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='" + src + "',sizingMethod='none')";
			}
		}
	}
}

if (document.all && !window.opera)
	attachEvent("onload", fixTrans);