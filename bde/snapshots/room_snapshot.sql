{% snapshot room_snapshot %}

 

{{

  config(

    target_schema='raw',

    strategy='timestamp',

    unique_key='LISTING_ID',

    updated_at='SCRAPED_DATE'

 

  )

}}

 

select  SCRAPED_DATE,HAS_AVAILABILITY,LISTING_ID,ROOM_TYPE

from {{ source('raw', 'listing') }}

 

{% endsnapshot %}

 