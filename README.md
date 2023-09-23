# Marketing-Analyst-Project

- 📝Topic of the project: Identify overall trends of all marketing campaigns on an e-commerce site, particularly look at dynamic weekday duration.
- 📖 The data set is a single parsed events table "turing_data_analytics.raw_events" which contains various frontend actions done on the e-commerce site. Data in the table contains records from 2020-11-01 until 2021-01-31.

## Overview of the anaysis: 
- Main Campaign data: Black Friday, New Year, Holiday
- Data Share Promo Campaign data
- No campaign data

## Main findings

### Main campaigns

#### Median duration per weekday for campaigns
<div>
<img src="https://github.com/Bversleg/Marketing-Analyst-Project/assets/126020538/e445ff52-4d14-48cc-a407-7e1cdf1bb66e" width="550"/>
<div>
  
> On Friday, Saturday and Sunday people spend most time on the website for the different campaigns.
>
> But we only have 189 users over all 6 campaigns and only 23 conversions over all 6 campaigns.
>
> Campaign data for Black Friday, New Year and Holiday was not recorded well. We need further investigation on the possibility to get this data via another data source.

### Data Share Promo campaign

#### Median duration per weekday for Data Share Promo campaign
<div>
<img src="https://github.com/Bversleg/Marketing-Analyst-Project/assets/126020538/cc4714de-6c8a-407e-81e1-1edc77570ca3" width="550"/>
<div>

> The goal of this campaign is to get the product known, not to make sales.
>
> The median duration time for this campaign was around 3 minutes, and users stayed the longest time on Wednesday.

### No campaign data

#### Median duration per weekday for user without campaign
<div>
<img src="https://github.com/Bversleg/Marketing-Analyst-Project/assets/126020538/5f5d6029-8d8d-4d8e-87fb-552ed44a5f08" width="550"/>
<div>

> Users spend the least time on the weekend.
> 
> Median duration is 1.5 minute.

#### Conversions per weekday for user without campaign
<div>
<img src="https://github.com/Bversleg/Marketing-Analyst-Project/assets/126020538/8a134cae-4642-473e-82a0-f3b155019691" width="550"/>
<div>

> On Fridays we see the highest conversion rates, of around 3%. Sundays also have fewest amount of conversions and lowest conversion rate of the week. 
>
> Average Conversion rate is 2.5%, which is average for an e-commerce website.

#### Conversions over time for users without a campaign
<div>
<img src="https://github.com/Bversleg/Marketing-Analyst-Project/assets/126020538/9cdabd7c-009a-4724-80a4-ed58989d7a42" width="550"/>
<div>

> Looking at conversion rate over time, it was the biggest just before the Christmas holidays. During the holiday period it decreased.

#### How many users without campaign are there per duration time?
<div>
<img src="https://github.com/Bversleg/Marketing-Analyst-Project/assets/126020538/375f1eee-cf4b-49c6-aef6-3965f3952a32" width="550"/>
<div>

> 69% of users stays less than 4 minutes on the website.

#### How many conversions are there per duration time?
<div>
<img src="https://github.com/Bversleg/Marketing-Analyst-Project/assets/126020538/a9f1edaf-6a4b-4c1c-ad15-2a7332f10d75" width="550"/>
<div>

>However, most conversions happen between 4 to 15 minutes.

## Actionable insights For the campaigns 
- Collect additional data for Black Friday, New Year and Holiday campaigns and improve data recording for the future.
- Analyse impressions for Data Share Promo campaign instead of conversions.
- Plan promotions for Data Share Promo on Wednesdays, as this is the day users spend the most time.

## Actionable insights For users without a campaign
- Plan promotions or offers on Fridays, because this is where we see the highest conversion rates.
- Optimize engagement on the website, especially on Saturdays and Sundays.
- Track and analyze the types of products or content that result in conversions between 4 and 15 minutes.
Since most conversions happen between 4 to 15 minutes, optimize the website to encourage users to stay within this timeframe.
    - We could do this by showing popular products, making sure the website is easy to navigate, and by optimizing the checkout process.

