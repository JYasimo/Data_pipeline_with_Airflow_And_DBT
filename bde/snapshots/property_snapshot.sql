{% snapshot property_snapshot %}


{{

  config(

    target_schema='raw',

    strategy='timestamp',

    unique_key='LISTING_ID',

    updated_at='SCRAPED_DATE'

  )

}}


select  SCRAPED_DATE,LISTING_ID,PROPERTY_TYPE,LISTING_NEIGHBOURHOOD

from {{ source('raw', 'listing') }}

 
{% endsnapshot %}

