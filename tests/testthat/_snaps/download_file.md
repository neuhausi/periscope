# downloadFileButton

    <span>
      <a id="myid-csv" class="btn btn-default shiny-download-link periscope-download-btn" href="" target="_blank" download>
        <i class="fa fa-download" role="presentation" aria-label="download icon"></i>
      </a>
      <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('myid-csv', 'tooltip', {'placement': 'top', 'trigger': 'hover', 'title': 'myhovertext'})}, 500)});</script>
    </span>

# downloadFileButton multiple types

    <span class="btn-group">
      <button aria-expanded="false" aria-haspopup="true" class="btn btn-default action-button dropdown-toggle periscope-download-btn" data-toggle="dropdown" id="myid-downloadFileList" type="button">
        <i class="fa fa-files-o" role="presentation" aria-label="files-o icon"></i>
      </button>
      <ul class="dropdown-menu" id="myid-testList">
        <li>
          <a id="myid-csv" class="shiny-download-link periscope-download-choice" href="" target="_blank" download>csv</a>
        </li>
        <li>
          <a id="myid-tsv" class="shiny-download-link periscope-download-choice" href="" target="_blank" download>tsv</a>
        </li>
      </ul>
      <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('myid-downloadFileList', 'tooltip', {'placement': 'top', 'trigger': 'hover', 'title': 'myhovertext'})}, 500)});</script>
    </span>

