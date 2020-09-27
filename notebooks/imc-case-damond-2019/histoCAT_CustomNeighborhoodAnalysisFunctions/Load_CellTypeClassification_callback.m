function [] = Load_CellTypeClassification_callback()
% Load_CellTypeClassification_callback: Loads a CSV with cell types
% classification, which was created externally. Needs to align with HashID
% and CellID's. Cell types need to be described as integer numbers

% Histology Topography Cytometry Analysis Toolbox (histoCAT)
% Denis Schapiro - Bodenmiller Group - UZH

% Retrieve GUI data
sessionData = retr('sessionData');
gates = retr('gates');
gate_context = retr('gateContext');
selected_gates = 1:size(gates, 1);

% Get only hashid's and cellid
CellID_HashID = sessionData(:,1:2);

% Load CSV files
[FileName,PathName,FilterIndex] = uigetfile('*.csv','Select CSV with Cell Types');
CSV_celltype_matrix = table2array(readtable(fullfile(PathName,FileName)));
CSV_CellID_HashID = CSV_celltype_matrix(:,1:2);

% Create empty arrays
Sorted_CSV_celltype_matrix = [];

% Order according to sessionData (CellID_HashID)
% Check if order of HashID's is the same
HashID_overlap = (CSV_celltype_matrix(:,1) == CellID_HashID(:,1));
if min(HashID_overlap)==0
    disp('HashIDs not the same order')
else
    % Check if CellID's align as well
    CellID_overlap = (CSV_CellID_HashID(:,2) == CellID_HashID(:,2));
    if min(CellID_overlap)==0
        
        for i=1:size(CellID_overlap,1)
            
            HashID_Loop_positive = [];
            CellID_Loop_positive = [];
            Intersection_HashID_CellID = [];
            
            % Find all HashIDs
            HashID_Loop_positive = find(CellID_HashID(:,1)==CSV_CellID_HashID(i,1));
            % Find all CellIDs
            CellID_Loop_positive = find(CellID_HashID(:,2)==CSV_CellID_HashID(i,2));
            % Find intersect
            Intersection_HashID_CellID = intersect(HashID_Loop_positive,CellID_Loop_positive);
            
            Sorted_CSV_celltype_matrix(Intersection_HashID_CellID,:) = CSV_celltype_matrix(i,[1,2,5]);
        end
    else
        disp('CellIDs overlap as well. CSV file can be added directly. Please add code')
        % Add cell types to session data
        %Function call to add the new channels
        [sessionData,gates] =  addChannels({'pseudotime','orderpseudotime','stageID','pseudostageID',...
            'Phenograph_External'}, CSV_celltype_matrix(:,3:end),...
            gate_context,selected_gates, gates, sessionData);
    end
    
end

% Check if all samples are present
if isequal(Sorted_CSV_celltype_matrix(:,1:2),Sorted_CellID_HashID)== 1
    % Add cell types to session data
    %Function call to add the new channels
    [sessionData,gates] =  addChannels({'Phenograph_External'}, Sorted_CSV_celltype_matrix(:,3),...
        gate_context,selected_gates, gates, sessionData);
    
else
    disp('CSV file does not fit the sessionData')
end

% Only select gates of interest
PseudoStageID_1= [1:size(CSV_celltype_matrix,1)];
PseudostageID_1_clean = PseudoStageID_1(CSV_celltype_matrix(:,5)==1);
gates_number = [];
k=1;

for i=1:size(gates,1)
    Detected_gate_number = intersect(gates{i,2},PseudostageID_1_clean);
    if isempty(Detected_gate_number)==1
        continue
    else
        gates_number(1,k) = i;
        k = k+1;
    end
end


%Get GUI handles
handles = gethand;
% selected_gates = get(handles.list_samples,'Value');
set(handles.list_samples, 'Value', gates_number);
uicontrol(handles.list_samples);
end