<CODEGEN_FILENAME><INTERFACE_NAME>Tests.dbl</CODEGEN_FILENAME>
<REQUIRES_CODEGEN_VERSION>5.5.3</REQUIRES_CODEGEN_VERSION>
<REQUIRES_OPTION>TF</REQUIRES_OPTION>
<CODEGEN_FOLDER>UnitTests</CODEGEN_FOLDER>
<REQUIRES_USERTOKEN>CLIENT_MODELS_NAMESPACE</REQUIRES_USERTOKEN>
<REQUIRES_USERTOKEN>DTOS_NAMESPACE</REQUIRES_USERTOKEN>
;//****************************************************************************
;//
;// Title:       InterfaceUnitTests.tpl
;//
;// Type:        CodeGen Template
;//
;// Description: Generates unit tests for former xfServerPlus methods in an SMC
;//              interface that have been exosed via Harmony Core Traditional
;//              Bridge and the use of the InterfaceController.tpl template.
;//
;// Copyright (c) 2020, Synergex International, Inc. All rights reserved.
;//
;// Redistribution and use in source and binary forms, with or without
;// modification, are permitted provided that the following conditions are met:
;//
;// * Redistributions of source code must retain the above copyright notice,
;//   this list of conditions and the following disclaimer.
;//
;// * Redistributions in binary form must reproduce the above copyright notice,
;//   this list of conditions and the following disclaimer in the documentation
;//   and/or other materials provided with the distribution.
;//
;// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
;// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
;// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
;// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
;// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
;// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
;// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
;// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
;// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
;// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
;// POSSIBILITY OF SUCH DAMAGE.
;//
;;*****************************************************************************
;;
;; Title:       <INTERFACE_NAME>Tests.dbl
;;
;; Description: Unit tests for the operations defined in <INTERFACE_NAME>Controller.
;;
;;*****************************************************************************
;; WARNING: GENERATED CODE!
;; This file was generated by CodeGen. Avoid editing the file if possible.
;; Any changes you make will be lost of the file is re-generated.
;;*****************************************************************************

import Microsoft.AspNetCore.JsonPatch
import Microsoft.VisualStudio.TestTools.UnitTesting
import Newtonsoft.Json
import System.Collections.Generic
import System.Net
import System.Net.Http
<IF DEFINED_ENABLE_AUTHENTICATION>
import System.Net.Http.Headers
</IF DEFINED_ENABLE_AUTHENTICATION>
import <CLIENT_MODELS_NAMESPACE>
import <DTOS_NAMESPACE>

namespace <NAMESPACE>

    {TestClass}
    public partial class <INTERFACE_NAME>Tests

<METHOD_LOOP>
        ;;------------------------------------------------------------
        ;;<METHOD_COMMENT>
  <IF IN_OR_INOUT>

        private m<METHOD_NAME>_Request, @<METHOD_NAME>_Request
  </IF IN_OR_INOUT>

        {TestMethod}
        {TestCategory("<INTERFACE_NAME> Tests")}
        public method <METHOD_NAME>, void
        proc
            ;;Get an HTTP client
            disposable data client = UnitTestEnvironment.Server.CreateClient()
  <IF DEFINED_ENABLE_AUTHENTICATION>
            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer",UnitTestEnvironment.AccessToken)
  </IF DEFINED_ENABLE_AUTHENTICATION>
  <IF IN_OR_INOUT>

            ;;Prepare the request
            data requestJson, string, JsonConvert.SerializeObject(m<METHOD_NAME>_Request)
            data requestBody, @StringContent, new StringContent(requestJson)
  </IF IN_OR_INOUT>

            ;;Make the HTTP call
  <IF IN_OR_INOUT>
            disposable data response = client.PostAsync("/<INTERFACE_NAME>/<METHOD_NAME>",requestBody).Result
  <ELSE>
            disposable data response = client.GetAsync("/<INTERFACE_NAME>/<METHOD_NAME>").Result
  </IF IN_OR_INOUT>

            ;;Throw if the HTTP operation failed
            response.EnsureSuccessStatusCode()
  <IF RETURNS_DATA>

            ;;Deal with the response
            data responseBodyJson = response.Content.ReadAsStringAsync().Result
            data responseDTO, @<METHOD_NAME>_Response, JsonConvert.DeserializeObject<<METHOD_NAME>_Response>(responseBodyJson)
  </IF RETURNS_DATA>

        endmethod

</METHOD_LOOP>
    endclass

endnamespace
