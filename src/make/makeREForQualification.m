function makeREForQualification

%change current folder to the location of make file
cd(fileparts(which('makeREForQualification')));

%create lib folder with libraries and configuration files
[status,result] = system(['..' filesep '..' filesep 'LoadAndCopyPackages.bat']);
if status ~= 0
    fprintf('%s\nLoadAndCopyPackages.bat failed\n\n',result);
    return;
end

%create a DCIMAtlabXXXCopy file (required for compiled version only)
libPath=['..' filesep 'lib' filesep];
[success, message] = copyfile([libPath 'DCIMatlabR2017b6_1.mexw64'], [libPath 'DCIMatlabR2017b6_1Copy.mexw64'], 'f');
if ~success
    fprintf('%s\nCopying DCIMatlabR2017b6_1.mexw64 failed\n\n',message);
    return;
end

%create destination directory 
distDir=['..' filesep 'dist'];
if ~exist(distDir,'dir')
    [success, message] = mkdir(distDir);
    if ~success
        fprintf('%s\nCreating dist directory failed\n\n',message);
        return;
    end
end

mcc -o CreateQualificationReport -m createQualificationReport.m QualificationWorkflow.m -W main ...
    -I '../code/engine_library/' ...
    -I '../code/qualification/' ...
	-I '../code/qualification/auxiliaries' ...
    -I '../code/templates/' ...
    -I '../matlab_toolbox/code/' ...
    -I '../matlab_toolbox/code/auxiliaries/' ...
    -I '../lib/' ...
    -a 'DCI6_1.dll' ...
    -a 'OSPSuite.FuncParser.dll' ...
    -a 'OSPSuite.SimModel.dll' ...
    -a 'OSPSuite.SimModel.xsd' ...
    -a 'OSPSuite.SimModelSolver_CVODES.dll' ...
    -a 'OSPSuite_SimModelComp.dll' ...
    -a 'OSPSuite_SimModelComp.xml' ...
    -d '../dist/' ...
    -v