Ext.data.JsonP.testing({"guide":"<h1>Unit Testing with Jasmine</h1>\n<div class='toc'>\n<p><strong>Contents</strong></p>\n<ol>\n<li><a href='#!/guide/testing-section-1'>I. Introduction</a></li>\n<li><a href='#!/guide/testing-section-2'>II. Getting started</a></li>\n<li><a href='#!/guide/testing-section-3'>III. Writing Tests</a></li>\n<li><a href='#!/guide/testing-section-4'>IV. Automating</a></li>\n<li><a href='#!/guide/testing-section-5'>Setting up PhantomJS:</a></li>\n</ol>\n</div>\n\n<h2 id='testing-section-1'>I. Introduction</h2>\n\n<p>In this tutorial we will take an existing Ext application and introduce the Jasmine assertion library for unit testing. Readers must be familiar with JavaScript, Ext JS 4, the MVC architecture as well as the fundamentals of HTML, CSS, and using resources.</p>\n\n<p><strong>Why Test?</strong> There are many reasons to test applications. Tests can verify an application's functionality to eliminate the need to enumerate all the use cases manually. Also, if the application were to be refactored, or updated, the tests could verify that the changes did not introduce new bugs into the system</p>\n\n<h2 id='testing-section-2'>II. Getting started</h2>\n\n<p>For this tutorial, use the \"simple\" example of the MVC in the ExtJS bundle — found under <code>&lt;ext&gt;/examples/app/simple</code>. Copy the simple folder to your workspace or desktop.</p>\n\n<p>Add these folders:</p>\n\n<pre><code>&lt;simple dir&gt;/app-test\n&lt;simple dir&gt;/app-test/specs\n</code></pre>\n\n<p><a href=\"http://pivotal.github.com/jasmine/download.html\">Download</a> and extract the Jasmine standalone library into the app-test folder.</p>\n\n<p>Create these files (leave them empty for now, you will fill them in next)</p>\n\n<pre><code>&lt;simple dir&gt;/app-test.js\n&lt;simple dir&gt;/run-tests.html\n</code></pre>\n\n<p><strong>Note:</strong> These file names are arbitrary. You may name them however you would like. These names were chosen simply from what they are. The <em>app-test.js</em> file is essentially <em>app.js</em> for testing purposes, and <em>run-tests.html</em> is simply the bootstrap.</p>\n\n<p>Your project should look like this now:</p>\n\n<p><p><img src=\"guides/testing/folder.jpg\" alt=\"\"></p></p>\n\n<p>Now that you have the files and folders set up, we'll create a test-running environment. This will be a web page that, when viewed, will run our tests and report the results. Open the run-tests.html and add the following markup:</p>\n\n<pre><code>&lt;html&gt;\n&lt;head&gt;\n    &lt;title id=\"page-title\"&gt;Tester&lt;/title&gt;\n\n    &lt;link rel=\"stylesheet\" type=\"text/css\" href=\"app-test/lib/jasmine-1.1.0/jasmine.css\"&gt;\n\n    &lt;script type=\"text/javascript\" src=\"extjs/ext-debug.js\"&gt;&lt;/script&gt;\n\n    &lt;script type=\"text/javascript\" src=\"app-test/lib/jasmine-1.1.0/jasmine.js\"&gt;&lt;/script&gt;\n    &lt;script type=\"text/javascript\" src=\"app-test/lib/jasmine-1.1.0/jasmine-html.js\"&gt;&lt;/script&gt;\n\n    &lt;!-- include specs here --&gt;\n\n    &lt;!-- test launcher --&gt;\n    &lt;script type=\"text/javascript\" src=\"app-test.js\"&gt;&lt;/script&gt;\n\n&lt;/head&gt;\n&lt;body&gt;\n&lt;/body&gt;\n&lt;/html&gt;\n</code></pre>\n\n<p>There are a few key things to remember here: the Jasmine resources, the Ext JS framework resource and app-test.js. These will need to be included with your tests (this order is important). You will include the specs (Jasmine assertion js files) above the app-test.js and below the rest of the files.</p>\n\n<p>Next, open app-test.js and copy this code into it:</p>\n\n<pre><code><a href=\"#!/api/Ext-method-require\" rel=\"Ext-method-require\" class=\"docClass\">Ext.require</a>('<a href=\"#!/api/Ext.app.Application\" rel=\"Ext.app.Application\" class=\"docClass\">Ext.app.Application</a>');\n\nvar Application = null;\n\n<a href=\"#!/api/Ext-method-onReady\" rel=\"Ext-method-onReady\" class=\"docClass\">Ext.onReady</a>(function() {\n    Application = <a href=\"#!/api/Ext-method-create\" rel=\"Ext-method-create\" class=\"docClass\">Ext.create</a>('<a href=\"#!/api/Ext.app.Application\" rel=\"Ext.app.Application\" class=\"docClass\">Ext.app.Application</a>', {\n        name: 'AM',\n\n        controllers: [\n            'Users'\n        ],\n\n        launch: function() {\n            //include the tests in the test.html head\n            jasmine.getEnv().addReporter(new jasmine.TrivialReporter());\n            jasmine.getEnv().execute();\n        }\n    });\n});\n</code></pre>\n\n<p>The effect of the above code is a global reference to the <em>Application</em> instance and bootstrap for the Jasmine assertion library. This is accomplished by directly constructing the <em>Application</em> object and storing the reference when the document is ready, bypassing the <a href=\"#!/api/Ext-method-application\" rel=\"Ext-method-application\" class=\"docClass\">Ext.application</a>() method.</p>\n\n<p><strong>Note:</strong> this <em>Application</em> definition is not a copy and paste of your regular <em>Application</em> definition in your app.js. This version will only include the controllers, stores, models, etc and when <em>launch</em> is called it will invoke the Jasmine tests.</p>\n\n<p>Now you should have a working test environment. Open the run-tests.html file in your browser to verify. You should see the Jasmine UI with a passing green bar that reads <code>0 specs, 0 failures in 0s</code>. Ex:</p>\n\n<p><p><img src=\"guides/testing/jasmine-setup.jpg\" alt=\"\"></p></p>\n\n<h2 id='testing-section-3'>III. Writing Tests</h2>\n\n<p>Under the specs folder (<code>&lt;simple&gt;/app-test/specs</code>) create two empty text files named:</p>\n\n<pre><code>example.js\nusers.js\n</code></pre>\n\n<p>Then go back to the <em>run-tests.html</em> file and add these two lines under the comment <em><code>&lt;!-- include specs here --&gt;</code></em></p>\n\n<pre><code>&lt;!-- include specs here --&gt;\n&lt;script type=\"text/javascript\" src=\"app-test/specs/example.js\"&gt;&lt;/script&gt;\n&lt;script type=\"text/javascript\" src=\"app-test/specs/users.js\"&gt;&lt;/script&gt;\n</code></pre>\n\n<p><strong>Note:</strong> Some examples use a <code>*.spec.js</code> double extention. It is not required, it is nice to indicate what the file is for. (in our case the folder of <code>specs</code> instead of just the double extension of <code>*.spec.js</code>)</p>\n\n<p>Start by filling in <code>specs/example.js</code>. Jasmine's specification syntax is very descriptive. Each suite of tests is contained in a describe function, and each test is defined by an \"it\" function.</p>\n\n<p>Example:</p>\n\n<pre><code>describe(\"Basic Assumptions\", function() {\n\n    it(\"has ExtJS4 loaded\", function() {\n        expect(Ext).toBeDefined();\n        expect(Ext.getVersion()).toBeTruthy();\n        expect(Ext.getVersion().major).toEqual(4);\n    });\n\n    it(\"has loaded AM code\",function(){\n        expect(AM).toBeDefined();\n    });\n});\n</code></pre>\n\n<p>To pass a test (each \"it\" block) simply call <code>expect(someValue).toBe&lt;something&gt;()</code></p>\n\n<p>Next a more complicated example. Testing a store, which is asynchronous, and retrieved from a Controller. (This is where that global application reference will come in handy) This code goes in <code>specs/users.js</code></p>\n\n<pre><code>describe(\"Users\", function() {\n    var store = null, ctlr = null;\n\n    beforeEach(function(){\n        if (!ctlr) {\n            ctlr = Application.getController('Users');\n        }\n\n        if (!store) {\n            store = ctlr.getStore('Users');\n        }\n\n        expect(store).toBeTruthy();\n\n        waitsFor(\n            function(){ return !store.isLoading(); },\n            \"load never completed\",\n            4000\n        );\n    });\n\n    it(\"should have users\",function(){\n        expect(store.getCount()).toBeGreaterThan(1);\n    });\n\n    it(\"should open the editor window\", function(){\n        var grid = <a href=\"#!/api/Ext.ComponentQuery-method-query\" rel=\"Ext.ComponentQuery-method-query\" class=\"docClass\">Ext.ComponentQuery.query</a>('userlist')[0];\n\n        ctlr.editUser(grid,store.getAt(0));\n\n        var edit = <a href=\"#!/api/Ext.ComponentQuery-method-query\" rel=\"Ext.ComponentQuery-method-query\" class=\"docClass\">Ext.ComponentQuery.query</a>('useredit')[0];\n\n        expect(edit).toBeTruthy();\n        if(edit)edit.destroy();\n    });\n\n});\n</code></pre>\n\n<p>Notice the \"beforeEach\" function (this will be called before each \"it\"). This function sets up the stage for each test, and this example:</p>\n\n<ol>\n<li>gets a <em>Store</em> from a <em>Controller</em></li>\n<li>asserts that the store was successfully retrieved (not null or undefined)</li>\n<li>waits for the store to complete loading -- see the \"waitFor\" function --\nThis store auto loads data when its constructed: do not run tests before its ready.</li>\n</ol>\n\n\n<h2 id='testing-section-4'>IV. Automating</h2>\n\n<p>Combining this with <a href=\"http://www.phantomjs.org/\">PhantomJS</a> allows us to run these tests from the command line or from a cron job. The provided <code>run-jasmine.js</code> in the PhantomJS distribution is all that is needed. (you can tweak it to make the output suit your needs, <a href=\"guides/testing/run-jasmine.js\">here</a> is an example tweaked version )</p>\n\n<p>Example command line:</p>\n\n<pre><code>phantomjs run-jasmine.js http://localhost/app/run-tests.html\n</code></pre>\n\n<p>You will need to run the tests from a web server because XHR's cannot be made\nfrom the <code>file://</code> protocol</p>\n\n<h2 id='testing-section-5'>Setting up PhantomJS:</h2>\n\n<p>On Windows and Mac (without mac ports) you will need to download the static binary from <a href=\"http://code.google.com/p/phantomjs/downloads/list\">here</a>. Once you have it downloaded extract it some place useful. (Ex: <code>&lt;profile dir&gt;/Applications/PhantomeJS</code>.) Then update your <code>PATH</code> environment variable to include the phantomjs binary. For Mac's open a terminal and edit either <code>.bashrc</code> or <code>.profile</code> and add this line to the bottom:</p>\n\n<pre><code>export PATH=$PATH:~/Applications/PhantomJS/bin\n</code></pre>\n\n<p>For Windows, open the <code>System Properties</code> control panel and select the <code>Advanced</code> tab and then click on the <code>Environment variables</code> button. Under the user variables box find and edit the <code>PATH</code> by adding this to the end:</p>\n\n<pre><code>;%USERPROFILE%\\Applications\\PhantomJS\n</code></pre>\n\n<p>If there is not an entry for <code>PATH</code> in the user variables, add one and set this as the value:</p>\n\n<pre><code>%PATH%;%USERPROFILE%\\Applications\\PhantomJS\n</code></pre>\n\n<p>Save your work by selecting the <code>OK</code> buttons and closing the windows.</p>\n\n<h3>Setting up PhantomJS (Alternative Path)</h3>\n\n<p>For Linux users and mac ports users there is a simple command to enter in the terminal to get and install PhantomJS.</p>\n\n<ul>\n<li><p> Debian(Ubuntu) based distribution use:</p>\n\n<pre><code>sudo apt-get install phantomjs.\n</code></pre></li>\n<li><p> RedHat(Fedora) based distribution use:</p>\n\n<pre><code>su -c 'yum install phantomjs'\n</code></pre></li>\n<li><p> Mac's with <a href=\"http://www.macports.org\">mac ports</a>, use:</p>\n\n<pre><code>sudo port install phantomjs.\n</code></pre></li>\n</ul>\n\n\n<h3>Verifying PhantomJS</h3>\n\n<p>To verify simply open a terminal (or command prompt) window and type this:</p>\n\n<pre><code>phantomjs --version\n</code></pre>\n\n<p>If there is output (other than \"command not found\") phantomjs is setup and ready for use.</p>\n\n<hr />\n\n<p><strong>About the Author:</strong> <a href=\"http://jonathangrimes.com\">Jonathan Grimes</a> (<a href=\"http://www.facebook.com/jonathan.grimes\">facebook</a>, <a href=\"http://twitter.com/jsg2021\">twitter</a>, <a href=\"https://plus.google.com/u/0/102578638400305127370/about\">google+</a>) is a software engineer at <a href=\"http://nextthought.com\">NextThought</a>, a technology start-up company that is currently building an integrated platform for online education.</p>\n","title":"Unit Testing"});