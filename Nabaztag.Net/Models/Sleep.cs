﻿using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using System;
using System.Collections.Generic;
using System.Text;

namespace Nabaztag.Net.Models
{
    /// <summary>
    /// {"type":"sleep","request_id":request_id}
    /// Emitter: services
    /// </summary>
    public class Sleep
    {
        /// <summary>
        /// Type sleep
        /// </summary>
        [JsonConverter(typeof(StringEnumConverter))]
        [JsonProperty(PropertyName = "type")]
        public PaquetType Type { get { return PaquetType.Sleep; } }

        /// <summary>
        /// 
        /// </summary>
        [JsonProperty(PropertyName = "request_id", NullValueHandling = NullValueHandling.Ignore)]
        public string RequestId { get; set; }
    }
}
