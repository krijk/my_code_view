package com.linknext.admob_flutter06;

import android.graphics.drawable.Drawable;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.RatingBar;
import android.widget.TextView;

import com.google.android.gms.ads.nativead.NativeAd;
import com.google.android.gms.ads.nativead.NativeAdView;

import java.util.Map;

import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory;

public class NativeAdFactoryExample implements NativeAdFactory {

    private final LayoutInflater layoutInflater;

    public NativeAdFactoryExample(LayoutInflater layoutInflater){
        this.layoutInflater = layoutInflater;
    }

    @Override
    public NativeAdView createNativeAd(NativeAd nativeAd, Map<String, Object> customOptions) {
        NativeAdView adView = (NativeAdView) layoutInflater.inflate(R.layout.my_native_ad01, null);

        adView.setMediaView(adView.findViewById(R.id.ad_media));
        adView.setBodyView(adView.findViewById(R.id.ad_body));
        adView.setCallToActionView(adView.findViewById(R.id.ad_call_to_action));
        adView.setIconView(adView.findViewById(R.id.ad_app_icon));
        adView.setPriceView(adView.findViewById(R.id.ad_price));
        adView.setStarRatingView(adView.findViewById(R.id.ad_stars));
        adView.setStoreView(adView.findViewById(R.id.ad_store));
        adView.setAdvertiserView(adView.findViewById(R.id.ad_advertiser));

        TextView headLineView = (TextView) adView.getHeadlineView();
        if(headLineView != null){
            String textHeadLine = nativeAd.getHeadline();
            if( textHeadLine != null){
                headLineView.setVisibility(View.VISIBLE);
                headLineView.setText(textHeadLine);
            }
            else{
                headLineView.setVisibility(View.INVISIBLE);
            }
        }

        TextView bodyView = (TextView) adView.getBodyView();
        if(bodyView != null){
            String textBody = nativeAd.getBody();
            if( textBody != null){
                bodyView.setVisibility(View.VISIBLE);
                bodyView.setText(textBody);
            }
            else{
                bodyView.setVisibility(View.INVISIBLE);
            }
        }

        TextView callToActionView = (TextView) adView.getCallToActionView();
        if(callToActionView != null){
            String textCallToAction = nativeAd.getCallToAction();
            if( textCallToAction != null){
                callToActionView.setVisibility(View.VISIBLE);
                callToActionView.setText(textCallToAction);
            }
            else{
                callToActionView.setVisibility(View.INVISIBLE);
            }
        }

        ImageView iconView = (ImageView) adView.getIconView();
        if(iconView != null){
            NativeAd.Image iconImage = nativeAd.getIcon();
            Drawable iconDrawable;
            if( iconImage != null){
                iconDrawable = iconImage.getDrawable();
            }
            else{
                iconDrawable = null;
            }
            if(iconDrawable != null){
                iconView.setImageDrawable(iconDrawable);
                iconView.setVisibility(View.VISIBLE);
            }
            else{
                iconView.setVisibility(View.GONE);
            }
        }

        TextView priceView = (TextView) adView.getPriceView();
        if(priceView != null){
            String textPrice = nativeAd.getPrice();
            if(textPrice != null){
                priceView.setText(textPrice);
                priceView.setVisibility(View.VISIBLE);
            }
            else{
                priceView.setVisibility(View.INVISIBLE);
            }
        }

        TextView storeView = (TextView) adView.getStoreView();
        if(storeView != null){
            String textStore = nativeAd.getStore();
            if(textStore != null){
                storeView.setText(textStore);
                storeView.setVisibility(View.VISIBLE);
            }
            else{
                storeView.setVisibility(View.INVISIBLE);
            }
        }

        RatingBar starRatingView = (RatingBar) adView.getStarRatingView();
        if(starRatingView != null){
            Double rateDouble = nativeAd.getStarRating();
            Float rateValue;
            if( rateDouble != null){
                rateValue = rateDouble.floatValue();
            }
            else{
                rateValue = null;
            }
            if(rateValue != null){
                starRatingView.setRating(rateValue);
                starRatingView.setVisibility(View.VISIBLE);
            }
            else{
                starRatingView.setVisibility(View.INVISIBLE);
            }
        }

        TextView advertiserView = (TextView) adView.getStoreView();
        if(advertiserView != null){
            String textAdvertiser = nativeAd.getAdvertiser();
            if(textAdvertiser != null){
                advertiserView.setText(textAdvertiser);
                advertiserView.setVisibility(View.VISIBLE);
            }
            else{
                advertiserView.setVisibility(View.INVISIBLE);
            }
        }

        // This method tells the Google Mobile Ads SDK that you have finished populating your
        // native ad view with this native ad.
        if (nativeAd != null) {
            adView.setNativeAd(nativeAd);
        }

        return adView;
    }
}
